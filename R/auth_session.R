# Auto-generated command wrappers for Authentication, Daemon, Sessions

auth_login <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "auth.login", ..., .body = .body, .protocol_version = .protocol_version)
}

auth_logout <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "auth.logout", ..., .body = .body, .protocol_version = .protocol_version)
}

auth_status <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "auth.status", ..., .body = .body, .protocol_version = .protocol_version)
}

daemon_doctor <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "daemon.doctor", ..., .body = .body, .protocol_version = .protocol_version)
}

daemon_start <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "daemon.start", ..., .body = .body, .protocol_version = .protocol_version)
}

daemon_status <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "daemon.status", ..., .body = .body, .protocol_version = .protocol_version)
}

daemon_stop <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "daemon.stop", ..., .body = .body, .protocol_version = .protocol_version)
}

daemon_version <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "daemon.version", ..., .body = .body, .protocol_version = .protocol_version)
}

session_close <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "session.close", ..., .body = .body, .protocol_version = .protocol_version)
}

session_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "session.list", ..., .body = .body, .protocol_version = .protocol_version)
}

session_open <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "session.open", ..., .body = .body, .protocol_version = .protocol_version)
}

session_reopen <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "session.reopen", ..., .body = .body, .protocol_version = .protocol_version)
}

session_status <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "session.status", ..., .body = .body, .protocol_version = .protocol_version)
}

session_use <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "session.use", ..., .body = .body, .protocol_version = .protocol_version)
}


