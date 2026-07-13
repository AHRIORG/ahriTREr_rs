# Auto-generated command wrappers for Local Commands

completion <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "completion", ..., .body = .body, .protocol_version = .protocol_version)
}

doctor <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "doctor", ..., .body = .body, .protocol_version = .protocol_version)
}

schema_get <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "schema.get", ..., .body = .body, .protocol_version = .protocol_version)
}

schema_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "schema.list", ..., .body = .body, .protocol_version = .protocol_version)
}

version <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "version", ..., .body = .body, .protocol_version = .protocol_version)
}


