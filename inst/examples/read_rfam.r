suppressPackageStartupMessages(library(ahritre))

load_project_env <- function() {
  env_file <- ".env"
  if (file.exists(env_file)) {
    readRenviron(env_file)
  }
}

runtime_preflight <- function() {
  runtime_root <- Sys.getenv("AHRI_TRE_RUNTIME_ROOT", unset = "")
  if (!nzchar(runtime_root)) {
    runtime_root <- "/opt/ahri-tre-runtime"
    Sys.setenv(AHRI_TRE_RUNTIME_ROOT = runtime_root)
  }

  runtime_root <- normalizePath(path.expand(runtime_root), mustWork = FALSE)
  manifest_path <- file.path(runtime_root, "share", "ahri-tre", "manifest.json")

  if (!file.exists(manifest_path)) {
    cat("[WARN] Runtime preflight failed: manifest not found at ", manifest_path, "\n", sep = "")
    cat("[INFO] To install runtime: bash .devcontainer/install_ahri_tre_runtime.sh\n")
    return(FALSE)
  }

  TRUE
}

is_connectivity_failure <- function(message) {
  grepl(
    paste(
      c(
        "AHRI TRE runtime manifest was not found",
        "runtime manifest was not found under the artifact root",
        "Failed to locate TRE runtime artifacts",
        "could not translate host name",
        "Temporary failure in name resolution",
        "Name or service not known",
        "Connection refused",
        "No route to host",
        "Network is unreachable",
        "timeout expired",
        "could not connect to server",
        "server is unreachable"
      ),
      collapse = "|"
    ),
    message,
    ignore.case = TRUE
  )
}

`%||%` <- function(lhs, rhs) {
  if (is.null(lhs)) rhs else lhs
}

normalize_records <- function(value) {
  if (is.null(value)) {
    return(data.frame())
  }
  if (is.data.frame(value)) {
    return(value)
  }
  if (is.character(value) && length(value) == 1L && nzchar(value)) {
    parsed <- try(jsonlite::fromJSON(value, simplifyDataFrame = TRUE), silent = TRUE)
    if (!inherits(parsed, "try-error")) {
      return(normalize_records(parsed))
    }
  }
  if (is.list(value)) {
    for (candidate in c("items", "rows", "data", "result", "output", "body", "studies", "datasets", "domains")) {
      if (!is.null(value[[candidate]])) {
        return(normalize_records(value[[candidate]]))
      }
    }
    as_df <- try(
      jsonlite::fromJSON(
        jsonlite::toJSON(value, auto_unbox = TRUE),
        simplifyDataFrame = TRUE
      ),
      silent = TRUE
    )
    if (!inherits(as_df, "try-error") && is.data.frame(as_df)) {
      return(as_df)
    }
  }
  data.frame()
}

first_present_column <- function(df, candidates) {
  present <- candidates[candidates %in% names(df)]
  if (length(present) == 0L) {
    return(rep(NA_character_, nrow(df)))
  }
  as.character(df[[present[[1]]]])
}

extract_rows_from_dataset_data <- function(result) {
  payloads <- result$payloads %||% list()
  arrow_payload_index <- which(vapply(payloads, function(p) identical(p$kind, "arrow_ipc"), logical(1)))[1]

  if (!is.na(arrow_payload_index)) {
    converted <- try(arrow_ipc_to_table(payloads[[arrow_payload_index]]), silent = TRUE)
    if (!inherits(converted, "try-error")) {
      return(as.data.frame(converted))
    }
    cat("[WARN] Arrow IPC payload detected but conversion failed; falling back to JSON body.\n")
  }

  normalize_records(result$data)
}

is_invalid_request_error <- function(value) {
  inherits(value, "try-error") && grepl("request envelope is invalid", as.character(value), fixed = TRUE)
}

is_no_live_session_error <- function(value) {
  inherits(value, "try-error") && grepl("no live session is selected", as.character(value), fixed = TRUE)
}

tre_cli_binary <- function() {
  runtime_root <- normalizePath(path.expand(Sys.getenv("AHRI_TRE_RUNTIME_ROOT", unset = "")), mustWork = FALSE)
  file.path(runtime_root, "bin", "ahri-tre")
}

parse_first_json_object <- function(lines) {
  if (length(lines) == 0L) {
    return(NULL)
  }
  text <- paste(lines, collapse = "\n")
  start <- regexpr("\\{", text)
  if (start[[1]] < 1L) {
    return(NULL)
  }
  json_text <- substr(text, start[[1]], nchar(text))
  parsed <- try(jsonlite::fromJSON(json_text, simplifyVector = FALSE), silent = TRUE)
  if (inherits(parsed, "try-error")) {
    return(NULL)
  }
  parsed
}

tre_cli_json <- function(args) {
  cli_bin <- tre_cli_binary()
  runtime_root <- normalizePath(path.expand(Sys.getenv("AHRI_TRE_RUNTIME_ROOT", unset = "")), mustWork = FALSE)
  runtime_lib <- file.path(runtime_root, "lib")
  env <- c(paste0("LD_LIBRARY_PATH=", paste(c(runtime_lib, Sys.getenv("LD_LIBRARY_PATH", unset = "")), collapse = ":")))

  output <- suppressWarnings(system2(cli_bin, args = args, stdout = TRUE, stderr = TRUE, env = env))
  parsed <- parse_first_json_object(output)
  if (is.null(parsed)) {
    stop("CLI command did not return parseable JSON: ", paste(output, collapse = "\n"), call. = FALSE)
  }
  parsed
}

is_daemon_unhealthy_message <- function(message_text) {
  grepl(
    paste(
      c(
        "daemon closed the protocol connection",
        "daemon socket",
        "stale"
      ),
      collapse = "|"
    ),
    message_text,
    ignore.case = TRUE
  )
}

tre_cli_restart_daemon <- function() {
  restart <- try(tre_cli_json(c("daemon", "start", "--format", "json")), silent = TRUE)
  if (inherits(restart, "try-error") || !isTRUE(restart$ok)) {
    return(FALSE)
  }
  TRUE
}

tre_cli_try_reopen_session <- function() {
  sessions_result <- try(tre_cli_json(c("session", "list", "--format", "json")), silent = TRUE)
  if (inherits(sessions_result, "try-error") || !isTRUE(sessions_result$ok)) {
    return(list(ok = FALSE, reason = "could not list sessions"))
  }

  sessions <- sessions_result$data$sessions %||% list()
  if (length(sessions) == 0L) {
    return(list(ok = FALSE, reason = "no known sessions"))
  }

  session_names <- vapply(sessions, function(s) s$session$name %||% "", character(1))
  auth_modes <- vapply(sessions, function(s) s$auth_mode %||% "", character(1))
  availability <- vapply(sessions, function(s) s$availability %||% "", character(1))
  candidates <- session_names[nzchar(session_names) & availability == "closed"]
  if (length(candidates) == 0L) {
    candidates <- session_names[nzchar(session_names)]
  }
  if (length(candidates) == 0L) {
    return(list(ok = FALSE, reason = "no usable session names"))
  }

  candidate_idx <- which(session_names == candidates[[1]])[[1]]
  candidate_auth_mode <- auth_modes[[candidate_idx]]
  if (identical(candidate_auth_mode, "legacy_password")) {
    return(list(
      ok = FALSE,
      reason = paste0(
        "session ", candidates[[1]],
        " uses legacy_password and cannot be reopened via session.reopen; recreate or open an OAuth session"
      )
    ))
  }

  reopen <- try(tre_cli_json(c("session", "reopen", candidates[[1]], "--format", "json")), silent = TRUE)
  if (inherits(reopen, "try-error") || !isTRUE(reopen$ok)) {
    reopen_message <- if (inherits(reopen, "try-error")) {
      as.character(reopen)
    } else {
      reopen$error$message %||% reopen$message %||% "session reopen failed"
    }
    return(list(ok = FALSE, reason = reopen_message))
  }
  list(ok = TRUE, reason = "reopened")
}

tre_cli_call <- function(args) {
  result <- tre_cli_json(args)
  retried <- FALSE

  if (!isTRUE(result$ok)) {
    message_text <- result$error$message %||% result$message %||% "unknown CLI error"
    if (is_daemon_unhealthy_message(message_text)) {
      if (tre_cli_restart_daemon()) {
        retried <- TRUE
        result <- tre_cli_json(args)
      }
    } else if (grepl("no live session is selected", message_text, fixed = TRUE)) {
      session_recovery <- tre_cli_try_reopen_session()
      if (isTRUE(session_recovery$ok)) {
        retried <- TRUE
        result <- tre_cli_json(args)
      } else {
        stop(
          paste0(
            "CLI call failed: ", message_text,
            " | recovery failed: ", session_recovery$reason,
            "; hint: run `ahri-tre session open-oauth <name> --profile <profile>` or recreate datastore session"
          ),
          call. = FALSE
        )
      }
    }
  }

  if (isTRUE(result$ok)) {
    if (isTRUE(retried)) {
      cat("[WARN] Recovered from daemon connectivity failure by restarting daemon and retrying CLI command.\n")
    }
    return(result)
  }
  message_text <- result$error$message %||% result$message %||% "unknown CLI error"
  stop("CLI call failed: ", message_text, call. = FALSE)
}

requested_domain_name <- "Basic Science"
requested_study_name <- "Rfam Database Collection"

load_project_env()

cat("[INFO] Using ahritre package wrappers.\n")
cat("[INFO] AHRI_TRE_RUNTIME_ROOT=", Sys.getenv("AHRI_TRE_RUNTIME_ROOT", unset = ""), "\n", sep = "")

if (!runtime_preflight()) {
  cat("[WARN] AHRI TRE runtime files are not installed for the configured artifact root; skipping script execution.\n")
  invisible(FALSE)
} else {
  bootstrap <- tryCatch(
    {
      client <- AhriTreClient()
      list(client = client)
    },
    error = function(e) {
      message_text <- conditionMessage(e)
      if (is_connectivity_failure(message_text)) {
        stop(
          paste0(
            "TRE runtime/datastore is unavailable. TRE_SERVER=",
            Sys.getenv("TRE_SERVER", unset = ""),
            ", TRE_TEST_DBNAME=",
            Sys.getenv("TRE_TEST_DBNAME", unset = ""),
            ". Details: ",
            message_text
          ),
          call. = FALSE
        )
      }
      stop(e)
    }
  )

  if (is.null(bootstrap)) {
    invisible(FALSE)
  } else {
    client <- bootstrap$client
    on.exit(close(client), add = TRUE)

    auth_state <- try(auth_status(client, format = "json"), silent = TRUE)
    if (inherits(auth_state, "try-error")) {
      cat("[WARN] Could not query auth status; continuing.\n")
    } else {
      cat("[INFO] Auth status queried successfully.\n")
    }

    domains_result <- try(domain_list(client, format = "json"), silent = TRUE)
    cli_fallback <- is_invalid_request_error(domains_result) || is_no_live_session_error(domains_result)

    if (cli_fallback) {
      cat("[WARN] Wrapper request shape rejected by runtime; falling back to ahri-tre CLI JSON flow.\n")
      studies_result <- tre_cli_call(c("study", "list", "--format", "json"))
      studies <- normalize_records(studies_result$data)
    } else {
      if (inherits(domains_result, "try-error")) {
        stop(as.character(domains_result), call. = FALSE)
      }

      domains <- normalize_records(domains_result$data)
      cat("\n[INFO] Domains found: ", nrow(domains), "\n", sep = "")
      if (nrow(domains) > 0) {
        print(utils::head(domains, 5))
      }

      domain_names <- first_present_column(domains, c("name", "domain", "domain_name"))
      if (!any(domain_names == requested_domain_name)) {
        stop("Domain not found: ", requested_domain_name)
      }

      studies_result <- study_list(client, format = "json")
      studies <- normalize_records(studies_result$data)
    }

    if (nrow(studies) > 0) {
      study_domain_col <- first_present_column(studies, c("domain", "domain_name", "domain-name"))
      if (!all(is.na(study_domain_col))) {
        studies <- studies[is.na(study_domain_col) | study_domain_col == requested_domain_name, , drop = FALSE]
      }
    }

    cat("\n[INFO] Studies found in domain filter: ", nrow(studies), "\n", sep = "")
    if (nrow(studies) > 0) {
      print(utils::head(studies, 5))
    }

    study_names <- first_present_column(studies, c("name", "study", "study_name"))
    if (!any(study_names == requested_study_name)) {
      stop("Study not found: ", requested_study_name)
    }

    cat("\n[INFO] Selected study: ", requested_study_name, "\n", sep = "")

    if (cli_fallback) {
      datasets_result <- tre_cli_call(c(
        "dataset", "list",
        "--study", requested_study_name,
        "--include-versions",
        "--format", "json"
      ))
    } else {
      datasets_result <- dataset_list(
        client,
        study = requested_study_name,
        include_versions = TRUE,
        format = "json"
      )
    }
    datasets <- normalize_records(datasets_result$data)
    cat("[INFO] Dataset entries found for selected study: ", nrow(datasets), "\n", sep = "")
    if (nrow(datasets) > 0) {
      print(utils::head(datasets, 5))
    }

    dataset_names <- unique(first_present_column(datasets, c("name", "dataset", "dataset_name")))
    dataset_names <- dataset_names[nzchar(dataset_names) & !is.na(dataset_names)]

    if (length(dataset_names) == 0L) {
      cat("[WARN] No dataset names resolved for study.\n")
      invisible(FALSE)
    } else {
      total_rows_read <- 0L

      for (i in seq_along(dataset_names)) {
        dataset_name <- dataset_names[[i]]
        cat("\n[INFO] Reading dataset ", i, "/", length(dataset_names), ": ", dataset_name, "\n", sep = "")

        data_result <- if (cli_fallback) {
          try(
            tre_cli_call(c(
              "dataset", "data",
              "--study", requested_study_name,
              "--dataset", dataset_name,
              "--limit", "10",
              "--format", "json"
            )),
            silent = TRUE
          )
        } else {
          try(
            dataset_data(
              client,
              study = requested_study_name,
              dataset = dataset_name,
              limit = 10L,
              format = "json"
            ),
            silent = TRUE
          )
        }

        if (inherits(data_result, "try-error")) {
          cat("[WARN] Dataset read failed: ", as.character(data_result), "\n", sep = "")
          next
        }

        rows <- if (cli_fallback) {
          normalize_records(data_result$data)
        } else {
          extract_rows_from_dataset_data(data_result)
        }
        total_rows_read <- total_rows_read + nrow(rows)
        cat("[INFO] Loaded dataset ", dataset_name, ": rows=", nrow(rows), ", cols=", ncol(rows), "\n", sep = "")

        if (ncol(rows) > 0) {
          print(rows[, seq_len(min(5, ncol(rows))), drop = FALSE])
        } else {
          print(rows)
        }
      }

      cat("\n[INFO] Total rows read across all datasets: ", total_rows_read, "\n", sep = "")
    }
  }
}
