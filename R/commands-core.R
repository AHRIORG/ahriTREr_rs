TRE_PROTOCOL_VERSION <- "1.0.0"

new_tre_protocol_request <- function(kind, body = list(), protocol_version = TRE_PROTOCOL_VERSION) {
  list(
    protocol_version = protocol_version,
    kind = kind,
    body = body %||% list()
  )
}

tre_command_call <- function(client, kind, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  body <- if (is.null(.body)) list(...) else .body
  execute_json(
    client = client,
    request = new_tre_protocol_request(
      kind = kind,
      body = body,
      protocol_version = .protocol_version
    )
  )
}


