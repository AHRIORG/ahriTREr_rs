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

asset_delete <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "asset.delete", ..., .body = .body, .protocol_version = .protocol_version)
}

asset_duo_clear <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "asset.duo.clear", ..., .body = .body, .protocol_version = .protocol_version)
}

asset_duo_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "asset.duo.list", ..., .body = .body, .protocol_version = .protocol_version)
}

asset_duo_replace <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "asset.duo.replace", ..., .body = .body, .protocol_version = .protocol_version)
}

asset_get <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "asset.get", ..., .body = .body, .protocol_version = .protocol_version)
}

asset_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "asset.list", ..., .body = .body, .protocol_version = .protocol_version)
}

asset_versions <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "asset.versions", ..., .body = .body, .protocol_version = .protocol_version)
}

auth_login <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "auth.login", ..., .body = .body, .protocol_version = .protocol_version)
}

auth_logout <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "auth.logout", ..., .body = .body, .protocol_version = .protocol_version)
}

auth_status <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "auth.status", ..., .body = .body, .protocol_version = .protocol_version)
}

completion <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "completion", ..., .body = .body, .protocol_version = .protocol_version)
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

datafile_delete <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "datafile.delete", ..., .body = .body, .protocol_version = .protocol_version)
}

datafile_export <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "datafile.export", ..., .body = .body, .protocol_version = .protocol_version)
}

datafile_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "datafile.list", ..., .body = .body, .protocol_version = .protocol_version)
}

datafile_metadata <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "datafile.metadata", ..., .body = .body, .protocol_version = .protocol_version)
}

datafile_search <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "datafile.search", ..., .body = .body, .protocol_version = .protocol_version)
}

dataset_data <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "dataset.data", ..., .body = .body, .protocol_version = .protocol_version)
}

dataset_delete <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "dataset.delete", ..., .body = .body, .protocol_version = .protocol_version)
}

dataset_export <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "dataset.export", ..., .body = .body, .protocol_version = .protocol_version)
}

dataset_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "dataset.list", ..., .body = .body, .protocol_version = .protocol_version)
}

dataset_metadata <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "dataset.metadata", ..., .body = .body, .protocol_version = .protocol_version)
}

dataset_preview <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "dataset.preview", ..., .body = .body, .protocol_version = .protocol_version)
}

dataset_search <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "dataset.search", ..., .body = .body, .protocol_version = .protocol_version)
}

dataset_withdraw <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "dataset.withdraw", ..., .body = .body, .protocol_version = .protocol_version)
}

datastore_adopt <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "datastore.adopt", ..., .body = .body, .protocol_version = .protocol_version)
}

datastore_create <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "datastore.create", ..., .body = .body, .protocol_version = .protocol_version)
}

datastore_info <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "datastore.info", ..., .body = .body, .protocol_version = .protocol_version)
}

datastore_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "datastore.list", ..., .body = .body, .protocol_version = .protocol_version)
}

datastore_ping <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "datastore.ping", ..., .body = .body, .protocol_version = .protocol_version)
}

datastore_rotate <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "datastore.rotate", ..., .body = .body, .protocol_version = .protocol_version)
}

datastore_schema <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "datastore.schema", ..., .body = .body, .protocol_version = .protocol_version)
}

doctor <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "doctor", ..., .body = .body, .protocol_version = .protocol_version)
}

domain_add <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "domain.add", ..., .body = .body, .protocol_version = .protocol_version)
}

domain_delete <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "domain.delete", ..., .body = .body, .protocol_version = .protocol_version)
}

domain_get <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "domain.get", ..., .body = .body, .protocol_version = .protocol_version)
}

domain_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "domain.list", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_add <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.add", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_delete <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.delete", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_get <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.get", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_instance_add <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.instance.add", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_instance_asset_link_add <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.instance.asset.link.add", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_instance_asset_link_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.instance.asset.link.list", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_instance_dataset_link_add <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.instance.dataset.link.add", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_instance_dataset_link_get <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.instance.dataset.link.get", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_instance_dataset_link_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.instance.dataset.link.list", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_instance_datasets <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.instance.datasets", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_instance_ensure <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.instance.ensure", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_instance_get <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.instance.get", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_instance_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.instance.list", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_instance_map_add <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.instance.map.add", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_instance_map_get <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.instance.map.get", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_instance_map_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.instance.map.list", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.list", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_relation_add <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.relation.add", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_relation_delete <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.relation.delete", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_relation_get <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.relation.get", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_relation_instance_add <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.relation.instance.add", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_relation_instance_asset_link_add <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.relation.instance.asset.link.add", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_relation_instance_asset_link_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.relation.instance.asset.link.list", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_relation_instance_dataset_link_add <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.relation.instance.dataset.link.add", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_relation_instance_dataset_link_get <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.relation.instance.dataset.link.get", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_relation_instance_dataset_link_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.relation.instance.dataset.link.list", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_relation_instance_ensure <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.relation.instance.ensure", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_relation_instance_get <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.relation.instance.get", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_relation_instance_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.relation.instance.list", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_relation_instance_map_add <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.relation.instance.map.add", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_relation_instance_map_get <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.relation.instance.map.get", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_relation_instance_map_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.relation.instance.map.list", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_relation_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.relation.list", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_relation_search <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.relation.search", ..., .body = .body, .protocol_version = .protocol_version)
}

entity_search <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "entity.search", ..., .body = .body, .protocol_version = .protocol_version)
}

ingest_datafile <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "ingest.datafile", ..., .body = .body, .protocol_version = .protocol_version)
}

ingest_dataset_datafile <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "ingest.dataset.datafile", ..., .body = .body, .protocol_version = .protocol_version)
}

ingest_dataset_sql <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "ingest.dataset.sql", ..., .body = .body, .protocol_version = .protocol_version)
}

ingest_dataset_table <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "ingest.dataset.table", ..., .body = .body, .protocol_version = .protocol_version)
}

ingest_redcap_project <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "ingest.redcap.project", ..., .body = .body, .protocol_version = .protocol_version)
}

schema_get <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "schema.get", ..., .body = .body, .protocol_version = .protocol_version)
}

schema_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "schema.list", ..., .body = .body, .protocol_version = .protocol_version)
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

study_access_grant <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "study.access.grant", ..., .body = .body, .protocol_version = .protocol_version)
}

study_access_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "study.access.list", ..., .body = .body, .protocol_version = .protocol_version)
}

study_access_revoke <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "study.access.revoke", ..., .body = .body, .protocol_version = .protocol_version)
}

study_add <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "study.add", ..., .body = .body, .protocol_version = .protocol_version)
}

study_add_domain <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "study.add.domain", ..., .body = .body, .protocol_version = .protocol_version)
}

study_clear_current <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "study.clear.current", ..., .body = .body, .protocol_version = .protocol_version)
}

study_context_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "study.context.list", ..., .body = .body, .protocol_version = .protocol_version)
}

study_current <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "study.current", ..., .body = .body, .protocol_version = .protocol_version)
}

study_custodians_add <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "study.custodians.add", ..., .body = .body, .protocol_version = .protocol_version)
}

study_custodians_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "study.custodians.list", ..., .body = .body, .protocol_version = .protocol_version)
}

study_custodians_remove <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "study.custodians.remove", ..., .body = .body, .protocol_version = .protocol_version)
}

study_custodians_transfer <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "study.custodians.transfer", ..., .body = .body, .protocol_version = .protocol_version)
}

study_delete <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "study.delete", ..., .body = .body, .protocol_version = .protocol_version)
}

study_duo_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "study.duo.list", ..., .body = .body, .protocol_version = .protocol_version)
}

study_duo_replace <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "study.duo.replace", ..., .body = .body, .protocol_version = .protocol_version)
}

study_get <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "study.get", ..., .body = .body, .protocol_version = .protocol_version)
}

study_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "study.list", ..., .body = .body, .protocol_version = .protocol_version)
}

study_search <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "study.search", ..., .body = .body, .protocol_version = .protocol_version)
}

study_use <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "study.use", ..., .body = .body, .protocol_version = .protocol_version)
}

tag_get <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "tag.get", ..., .body = .body, .protocol_version = .protocol_version)
}

tag_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "tag.list", ..., .body = .body, .protocol_version = .protocol_version)
}

tag_set <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "tag.set", ..., .body = .body, .protocol_version = .protocol_version)
}

transformation_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "transformation.list", ..., .body = .body, .protocol_version = .protocol_version)
}

variable_add <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "variable.add", ..., .body = .body, .protocol_version = .protocol_version)
}

variable_delete <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "variable.delete", ..., .body = .body, .protocol_version = .protocol_version)
}

variable_get <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "variable.get", ..., .body = .body, .protocol_version = .protocol_version)
}

variable_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "variable.list", ..., .body = .body, .protocol_version = .protocol_version)
}

variable_search <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "variable.search", ..., .body = .body, .protocol_version = .protocol_version)
}

variable_update <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "variable.update", ..., .body = .body, .protocol_version = .protocol_version)
}

version <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "version", ..., .body = .body, .protocol_version = .protocol_version)
}

vocabulary_add <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "vocabulary.add", ..., .body = .body, .protocol_version = .protocol_version)
}

vocabulary_delete <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "vocabulary.delete", ..., .body = .body, .protocol_version = .protocol_version)
}

vocabulary_get <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "vocabulary.get", ..., .body = .body, .protocol_version = .protocol_version)
}

vocabulary_list <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {
  tre_command_call(client, "vocabulary.list", ..., .body = .body, .protocol_version = .protocol_version)
}


