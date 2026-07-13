# TRE Public Command Reference

Generated from TRE Public Interfaces.csv. Grouped by category.

## Assets, Datafiles, Datasets

| Command | Function | Runtime Context | Study Context | Important Inputs | Output | Status and Purpose |
|---|---|---|---|---|---|---|
| asset delete | asset_delete | datastore-operation | single-study | --name, --reason, optional --actor, --cascade, --force, --dry-run, --yes, --format | Archive/delete plan or result | Delete all versions of a supported asset through archive/delete policy; requires primary or delegate study custodianship. |
| asset duo clear | asset_duo_clear | datastore-operation | single-study | --asset, optional --version, --format | Asset-version DUO clear result | Remove explicit DUO overrides for one asset version so effective readback can fall back to study defaults. |
| asset duo list | asset_duo_list | datastore-operation | single-study | --asset, optional --version, --effective, --format | Asset-version DUO restriction list | List explicit DUO restrictions for one asset version, or effective restrictions with source values when --effective is set. |
| asset duo replace | asset_duo_replace | datastore-operation | single-study | --asset, optional --version, --restrictions, --format | Asset-version DUO replacement result | Replace the explicit DUO override set for one asset version; empty arrays are rejected in favor of asset duo clear. |
| asset get | asset_get | datastore-operation | single-study | --name, optional --type, --format | Asset record | Fetch one asset. |
| asset list | asset_list | datastore-operation | single-study | Optional --type dataset\\|file; --format | Asset list | List assets in the resolved study. |
| asset versions | asset_versions | datastore-operation | single-study | --asset, optional --type, --format | Asset-version list | List versions of one asset. |
| datafile delete | datafile_delete | datastore-operation | single-study | --asset, optional --version latest\\|<semver>\\|all, --reason, optional --actor, --cascade, --force, --dry-run, --yes, --format | Archive/delete plan or result | Delete a datafile version or whole datafile asset with managed payload cleanup; requires primary or delegate study custodianship. |
| datafile export | datafile_export | datastore-operation | single-study | --asset, optional --version, --to, --overwrite, --format | Export status | Copy a managed datafile payload to a requested path. |
| datafile list | datafile_list | datastore-operation | single-study | --include-versions, --format | Datafile asset list | List managed datafile assets and optionally their versions. |
| datafile metadata | datafile_metadata | datastore-operation | single-study | --asset, optional --version, --format | Datafile metadata | Show one datafile asset/version. |
| datafile search | datafile_search | datastore-operation | single-study | Name/description/format/study/tag filters; --cursor, --limit, --width, --format | Datafile search results | Search bounded datafile catalog summaries without reading file payloads. |
| dataset data | dataset_data | datastore-operation | single-study | --dataset, optional --limit, --to, --format arrow\\|parquet\\|csv\\|json, --compress | Tabular data stream or export file | Read or export dataset data. |
| dataset delete | dataset_delete | datastore-operation | single-study | --dataset, optional --version latest\\|<semver>\\|all, --reason, optional --actor, --cascade, --force, --dry-run, --yes, --format | Archive/delete plan or result | Delete a dataset version or whole dataset asset with mandatory lake table cleanup; requires primary or delegate study custodianship. |
| dataset export | dataset_export | datastore-operation | single-study | --dataset, optional --limit, --to, --format arrow\\|parquet\\|csv\\|json, --compress | Export file | Export dataset rows to a file or directory-derived file. |
| dataset list | dataset_list | datastore-operation | single-study | --include-versions, --format | Dataset list | List dataset assets and optionally their versions. |
| dataset metadata | dataset_metadata | datastore-operation | single-study | --dataset, --with-variables, --format | Dataset metadata | Show dataset metadata and variable count; --with-variables includes variable definitions. |
| dataset preview | dataset_preview | datastore-operation | single-study | --dataset, --limit, optional --width, --format | Text or JSON row preview | Preview dataset rows. |
| dataset search | dataset_search | datastore-operation | single-study | Name/description/version-label/study/domain/tag filters; --cursor, --limit, --width, --format | Dataset search results | Search bounded dataset catalog summaries; row filtering stays in dataset data/preview/export paths. |
| dataset withdraw | dataset_withdraw | datastore-operation | single-study | --dataset, --version, --reason, optional --actor, --force, --drop-lake-table, --format | Withdrawal result | Withdraw one faulty dataset version with audited provenance; requires primary or delegate study custodianship. |

## Authentication, Daemon, Sessions

| Command | Function | Runtime Context | Study Context | Important Inputs | Output | Status and Purpose |
|---|---|---|---|---|---|---|
| auth login | auth_login | auth-management | not-applicable | --write-token-file, --write-auth-context, --cache-token, --format | Text or JSON auth artifact summary | Run interactive OAuth and optionally persist reusable auth material. |
| auth logout | auth_logout | auth-management | not-applicable | Optional global --auth-context; --token-file, --cached, --format | Text or JSON logout status | Remove token material. |
| auth status | auth_status | auth-management | not-applicable | Optional global auth-source flags; --format | Text or JSON auth status | Inspect reusable auth material. |
| daemon doctor | daemon_doctor | local-only | not-applicable | Reachable daemon; --format text\\|json | Text or daemon.doctor protocol envelope | Query daemon runtime, socket, state, session, and protocol readiness checks. |
| daemon start | daemon_start | local-only | not-applicable | --format text\\|json | Text or JSON daemon status | Start the local daemon process. |
| daemon status | daemon_status | local-only | not-applicable | --format text\\|json | Text or JSON daemon status | Inspect daemon reachability. |
| daemon stop | daemon_stop | local-only | not-applicable | --format text\\|json | Text or JSON daemon status | Stop the local daemon. |
| daemon version | daemon_version | local-only | not-applicable | Reachable daemon; --format text\\|json | Text or daemon.version protocol envelope | Query running daemon build identity and protocol compatibility. |
| session close [name] | session_close | session-management | not-applicable | Optional name; --all | Text status | Close one or all sessions. |
| session list | session_list | session-management | not-applicable | None | Text list | List known local sessions, including the Authenticated TRE user for live authenticated sessions. |
| session open-oauth <name> | session_open | session-management | not-applicable | Issuer, client, subject, expiry, and token env flags: Stored auth path: --profile, --env-file; session name | Text session status | Open an interactive OAuth-backed live session. Open a live session from stored OAuth material. Open a live session from an injected token. |
| session reopen <name> | session_reopen | session-management | not-applicable | --force-reauth, --clear-token-cache | Text session status | Reopen a persisted non-secret session. |
| session status [name] | session_status | session-management | not-applicable | Optional session name | Text status | Show session metadata and live state. |
| session use <name> | session_use | session-management | not-applicable | Session name | Text status | Select the active local session. |

## Datastore, Semantic Catalog

| Command | Function | Runtime Context | Study Context | Important Inputs | Output | Status and Purpose |
|---|---|---|---|---|---|---|
| datastore adopt | datastore_adopt | datastore-operation | no-study | Existing datastore/catalog/lake values, temporary lake credential inputs, --super-user, --super-password-env, --yes, optional --format | Text or JSON adoption report | Verify a legacy datastore and write a ready identity binding with managed lake catalog credentials. |
| datastore create | datastore_create | datastore-operation | no-study | --datastore or TRE_DATASTORE, optional --lake-base-path, --super-user, --super-password-env, --force, --yes, optional --port, --format | Text or JSON creation report | Provision datastore metadata, roles, lake catalog state, managed catalog credentials, and the datastore-local identity binding. |
| datastore info | datastore_info | datastore-operation | no-study | TRE_DATASTORE or session/profile context; --format text\\|json | Text or JSON runtime summary | Summarize datastore identity, safe binding status, connection metadata, lake state, and content counts. |
| datastore list | datastore_list | datastore-operation | no-study | --super-user, --super-password-env; optional server/port/SSL/bootstrap overrides; --format text\\|json | Text table or JSON discovery response | Discover AHRI TRE datastores on the current PostgreSQL server using metadata-only inspection. |
| datastore ping | datastore_ping | datastore-operation | no-study | TRE_DATASTORE or session/profile context; --format text\\|json | Text or JSON connectivity result | Check datastore reachability and identity-binding verification. |
| datastore rotate-lake-credential | datastore_rotate | datastore-operation | no-study | Datastore identity, store owner credential env, --super-user, --super-password-env, --yes, optional --format | Text or JSON rotation report | Rotate the managed DuckLake catalog role password without changing ordinary open profiles. |
| datastore schema-status | datastore_schema | datastore-operation | no-study | (status, plan, migrate) datastore, --super-user, --super-password-env, optional --port, --format | Text or JSON schema compatibility status | Inspect metadata schema version, migration history, missing tables, and DuckLake catalog migration ownership. Report pending/adoptable/blocked migration steps without applying them. Apply supported datastore metadata schema migrations and report before/after status. |
| domain add | domain_add | datastore-operation | no-study | --name, optional --uri, --description, --format | Domain record | Add or validate a semantic domain. |
| domain delete <name> | domain_delete | datastore-operation | no-study | Domain name, --reason, optional --actor, --dry-run, --yes, --format | Semantic delete plan or result | Physically delete an unused domain or block with dependency summary; no archive/retirement semantics. |
| domain get <name> | domain_get | datastore-operation | no-study | Domain name; --format | Domain record | Fetch one domain. |
| domain list | domain_list | datastore-operation | no-study | --format text\\|json | Domain list | List semantic domains. |
| tag get | tag_get | datastore-operation | no-study or single-study | --target, --name, optional --domain, --version, --asset-type, --format | Tags for target | Inspect tags on domains, studies, variables, entities, relations, assets, datafiles, datasets, and versions. |
| tag list | tag_list | datastore-operation | no-study | --format | Tag registry | List normalized tag labels through the stable protocol. |
| tag set | tag_set | datastore-operation | no-study or single-study | --target, --name, repeated --tag or --clear, optional --domain, --version, --asset-type, --format | Updated tags for target | Replace the complete tag set for a supported target or clear all tags. |
| variable add | variable_add | datastore-operation | no-study | Domain, name, value type, optional ontology/vocabulary fields, --format | Variable record | Add a variable definition. |
| variable delete | variable_delete | datastore-operation | no-study | --domain, --name, --reason, optional --actor, --dry-run, --yes, --format | Semantic delete plan or result | Physically delete an unused variable definition or block while preserving dataset/provenance meaning. |
| variable get | variable_get | datastore-operation | no-study | --domain, --name, --format | Variable record | Fetch one variable. |
| variable list | variable_list | datastore-operation | no-study or single-study | Optional --domain; --format | Variable list | List semantic variables by domain, or by resolved study when no domain is provided. |
| variable search | variable_search | datastore-operation | no-study | Text/domain/value-type/vocabulary/key-role/tag filters; --cursor, --limit, --width, --format | Variable search results | Search bounded dictionary variable summaries without reading dataset rows. |
| variable update | variable_update | datastore-operation | no-study | Domain, name, optional replacement fields, --format | Variable record | Update variable metadata. |
| vocabulary add | vocabulary_add | datastore-operation | no-study | --domain, --name, --items, optional description, --format | Vocabulary record | Add a vocabulary and items. |
| vocabulary delete | vocabulary_delete | datastore-operation | no-study | --domain, --name, --reason, optional --actor, --dry-run, --yes, --format | Semantic delete plan or result | Physically delete an unused vocabulary definition or block on variables, items, mappings, and history. |
| vocabulary get | vocabulary_get | datastore-operation | no-study | --domain, --name, --format | Vocabulary detail | Fetch one vocabulary and its items; JSON protocol output exposes items at .data.vocabulary.items. |
| vocabulary list | vocabulary_list | datastore-operation | no-study or single-study | Optional --domain; --format | Vocabulary list | List vocabularies by domain, or by resolved study when no domain is provided. |

## Entities, Relations, Transformations, Ingest

| Command | Function | Runtime Context | Study Context | Important Inputs | Output | Status and Purpose |
|---|---|---|---|---|---|---|
| entity delete | entity_delete | datastore-operation | no-study | --domain, --name, --reason, optional --actor, --dry-run, --yes, --format | Semantic delete plan or result | Physically delete an unused entity definition or block on relation, instance, mapping, and link dependencies. |
| entity instance asset-link add\\|list | entity_instance_asset_link_add | datastore-operation | single-study | Instance ID, asset, optional version, transformation ID, optional --width, --format | Asset-link record or empty asset-link list | Manage and audit links between entity instances and asset versions. |
| entity instance asset-link add\\|list | entity_instance_asset_link_list | datastore-operation | single-study | Instance ID, asset, optional version, transformation ID, optional --width, --format | Asset-link record or empty asset-link list | Manage and audit links between entity instances and asset versions. |
| entity instance dataset-link add\\|get\\|list | entity_instance_dataset_link_add | datastore-operation | single-study | Instance ID, dataset, variable, optional version, transformation ID, optional --width, --format | Dataset-link record or empty dataset-link readback | Manage and audit links between entity instances and dataset variables. |
| entity instance dataset-link add\\|get\\|list | entity_instance_dataset_link_get | datastore-operation | single-study | Instance ID, dataset, variable, optional version, transformation ID, optional --width, --format | Dataset-link record or empty dataset-link readback | Manage and audit links between entity instances and dataset variables. |
| entity instance dataset-link add\\|get\\|list | entity_instance_dataset_link_list | datastore-operation | single-study | Instance ID, dataset, variable, optional version, transformation ID, optional --width, --format | Dataset-link record or empty dataset-link readback | Manage and audit links between entity instances and dataset variables. |
| entity instance datasets | entity_instance_datasets | datastore-operation | single-study | --instance-id, optional --width, --format | Dataset readback list | List dataset versions linked to an entity instance. |
| entity instance ensure-from-dataset | entity_instance_ensure | datastore-operation | single-study | Domain, entity, dataset, external-id variable, optional version/template, --dry-run, --format | Instance plan or result | Ensure entity instances from dataset rows. |
| entity instance get\\|list\\|add | entity_instance_add | datastore-operation | no-study | Instance ID or domain/entity inputs, transformation ID, labels/notes, --format | Entity instance records | Inspect or register entity instances. |
| entity instance get\\|list\\|add | entity_instance_get | datastore-operation | no-study | Instance ID or domain/entity inputs, transformation ID, labels/notes, --format | Entity instance records | Inspect or register entity instances. |
| entity instance get\\|list\\|add | entity_instance_list | datastore-operation | no-study | Instance ID or domain/entity inputs, transformation ID, labels/notes, --format | Entity instance records | Inspect or register entity instances. |
| entity instance map add\\|get\\|list | entity_instance_map_add | datastore-operation | no-study | Instance ID, external ID, domain/entity filters, transformation ID, optional --width, --format | Mapping records or empty mapping list | Manage and audit study-scoped entity external-ID mappings. |
| entity instance map add\\|get\\|list | entity_instance_map_get | datastore-operation | no-study | Instance ID, external ID, domain/entity filters, transformation ID, optional --width, --format | Mapping records or empty mapping list | Manage and audit study-scoped entity external-ID mappings. |
| entity instance map add\\|get\\|list | entity_instance_map_list | datastore-operation | no-study | Instance ID, external ID, domain/entity filters, transformation ID, optional --width, --format | Mapping records or empty mapping list | Manage and audit study-scoped entity external-ID mappings. |
| entity list\\|get\\|add | entity_add | datastore-operation | no-study | Domain, entity name, optional metadata fields, --format | Entity records | Manage semantic entity definitions. |
| entity list\\|get\\|add | entity_get | datastore-operation | no-study | Domain, entity name, optional metadata fields, --format | Entity records | Manage semantic entity definitions. |
| entity list\\|get\\|add | entity_list | datastore-operation | no-study | Domain, entity name, optional metadata fields, --format | Entity records | Manage semantic entity definitions. |
| entity search | entity_search | datastore-operation | no-study | Domain/name/description/ontology/tag filters; --cursor, --limit, --width, --format | Entity search results | Search bounded semantic entity definition summaries. |
| entity-relation delete | entity_relation_delete | datastore-operation | no-study | --domain, --name, --reason, optional --actor, --dry-run, --yes, --format | Semantic delete plan or result | Physically delete an unused relation definition or block on relation-instance, mapping, link, and history dependencies. |
| entity-relation instance asset-link add\\|list | entity_relation_instance_asset_link_add | datastore-operation | single-study | Relation instance ID, asset, optional version, transformation ID, optional --width, --format | Asset-link record or empty asset-link list | Manage and audit links between relation instances and asset versions. |
| entity-relation instance asset-link add\\|list | entity_relation_instance_asset_link_list | datastore-operation | single-study | Relation instance ID, asset, optional version, transformation ID, optional --width, --format | Asset-link record or empty asset-link list | Manage and audit links between relation instances and asset versions. |
| entity-relation instance dataset-link add\\|get\\|list | entity_relation_instance_dataset_link_add | datastore-operation | single-study | Relation instance ID, dataset, subject/object variables, optional relation variable/version, transformation ID, optional --width, --format | Dataset-link record or empty dataset-link readback | Manage and audit links between relation instances and dataset variables, including endpoint and validity context. |
| entity-relation instance dataset-link add\\|get\\|list | entity_relation_instance_dataset_link_get | datastore-operation | single-study | Relation instance ID, dataset, subject/object variables, optional relation variable/version, transformation ID, optional --width, --format | Dataset-link record or empty dataset-link readback | Manage and audit links between relation instances and dataset variables, including endpoint and validity context. |
| entity-relation instance dataset-link add\\|get\\|list | entity_relation_instance_dataset_link_list | datastore-operation | single-study | Relation instance ID, dataset, subject/object variables, optional relation variable/version, transformation ID, optional --width, --format | Dataset-link record or empty dataset-link readback | Manage and audit links between relation instances and dataset variables, including endpoint and validity context. |
| entity-relation instance ensure-from-dataset | entity_relation_instance_ensure | datastore-operation | single-study | Domain, relation, dataset, relation/subject/object variables, optional validity variables/version, --dry-run, --format | Relation-instance plan or result | Ensure relation instances from dataset rows. |
| entity-relation instance get\\|list\\|add | entity_relation_instance_add | datastore-operation | no-study | Relation instance ID or domain/name inputs, subject/object instance IDs, transformation ID, validity fields, --format | Relation instance records | Inspect or register relation instances. |
| entity-relation instance get\\|list\\|add | entity_relation_instance_get | datastore-operation | no-study | Relation instance ID or domain/name inputs, subject/object instance IDs, transformation ID, validity fields, --format | Relation instance records | Inspect or register relation instances. |
| entity-relation instance get\\|list\\|add | entity_relation_instance_list | datastore-operation | no-study | Relation instance ID or domain/name inputs, subject/object instance IDs, transformation ID, validity fields, --format | Relation instance records | Inspect or register relation instances. |
| entity-relation instance map add\\|get\\|list | entity_relation_instance_map_add | datastore-operation | no-study | Relation instance ID, external ID, domain/name filters, transformation ID, optional --width, --format | Mapping records or empty mapping list | Manage and audit study-scoped relation external-ID mappings, including endpoint context. |
| entity-relation instance map add\\|get\\|list | entity_relation_instance_map_get | datastore-operation | no-study | Relation instance ID, external ID, domain/name filters, transformation ID, optional --width, --format | Mapping records or empty mapping list | Manage and audit study-scoped relation external-ID mappings, including endpoint context. |
| entity-relation instance map add\\|get\\|list | entity_relation_instance_map_list | datastore-operation | no-study | Relation instance ID, external ID, domain/name filters, transformation ID, optional --width, --format | Mapping records or empty mapping list | Manage and audit study-scoped relation external-ID mappings, including endpoint context. |
| entity-relation list\\|get\\|add | entity_relation_add | datastore-operation | no-study | Domain, relation name, subject, object, optional metadata fields, --format | Relation records | Manage semantic relation definitions. |
| entity-relation list\\|get\\|add | entity_relation_get | datastore-operation | no-study | Domain, relation name, subject, object, optional metadata fields, --format | Relation records | Manage semantic relation definitions. |
| entity-relation list\\|get\\|add | entity_relation_list | datastore-operation | no-study | Domain, relation name, subject, object, optional metadata fields, --format | Relation records | Manage semantic relation definitions. |
| entity-relation search | entity_relation_search | datastore-operation | no-study | Domain/name/description/source/target/ontology/tag filters; --cursor, --limit, --width, --format | Relation search results | Search bounded semantic relation definition summaries with source/target endpoint context. |
| ingest datafile | ingest_datafile | datastore-operation | single-study | --asset, --path or --uri, file --format, versioning, encryption, hash, verification flags, --output-format | Ingest result | Register and copy or reference a managed datafile. |
| ingest dataset from-datafile | ingest_dataset_datafile | datastore-operation | single-study | Domain, dataset, source asset/version, file format, description, replacement/versioning and parsing flags | Materialization result | Materialize a dataset asset from a managed datafile. |
| ingest dataset from-sql | ingest_dataset_sql | datastore-operation | single-study | Domain, dataset, flavour, SQL, description, replacement/versioning and source connection flags, --format | Dataset ingest result | Materialize a dataset from SQL source data. |
| ingest dataset table | ingest_dataset_table | datastore-operation | single-study | Domain, dataset, --path or --uri, table format, description, replacement/versioning and parsing flags, --output-format | Dataset ingest result | Ingest an external table source directly as a dataset asset. |
| ingest redcap project | ingest_redcap_project | datastore-operation | single-study | --domain, optional API URL/token env, dataset and dictionary flags, --format | REDCap ingest result | Ingest REDCap project artifacts and materialized form datasets. |
| transformation list | transformation_list | datastore-operation | single-study | --format | Transformation summary list | List transformations that produced versions in the resolved study. |

## Local Commands

| Command | Function | Runtime Context | Study Context | Important Inputs | Output | Status and Purpose |
|---|---|---|---|---|---|---|
| completion <shell> | completion | local-only | not-applicable | bash, elvish, fish, powershell, or zsh | Shell completion script | Generate completions for the public CLI. |
| doctor | doctor | diagnostic | not-applicable | --strict; optional runtime/profile/auth flags | Text or JSON readiness report | Check local, session, and Automation readiness. |
| schema get <schema-id> | schema_get | local-only | not-applicable | Schema ID; --format text\\|json | Schema document | Print one known JSON Schema document. |
| schema list | schema_list | local-only | not-applicable | --format text\\|json | Schema identifiers | List stable JSON control-plane schema IDs and the coverage map. |
| version | version | local-only | not-applicable | --format text\\|json | Text version or JSON build metadata | Print CLI version and build metadata. |

## Runtime

| Command | Function | Runtime Context | Study Context | Important Inputs | Output | Status and Purpose |
|---|---|---|---|---|---|---|
| auth-management | auth-management | Creates, inspects, or removes reusable authentication material. |  |  |  |  |
| datastore-operation | datastore-operation | Requires either a daemon-backed live session or explicit Automation inputs when the command supports Automation. |  |  |  |  |
| diagnostic | diagnostic | Can inspect local, configured, session-backed, or Automation readiness depending on supplied flags. |  |  |  |  |
| local-only | local-only | Does not require a daemon, session, profile, auth source, datastore, or lake access. |  |  |  |  |
| session-management | session-management | Opens, selects, inspects, reopens, or closes local live datastore sessions. |  |  |  |  |

## Study, Governance

| Command | Function | Runtime Context | Study Context | Important Inputs | Output | Status and Purpose |
|---|---|---|---|---|---|---|
| study access grant | study_access_grant | datastore-operation | single-study | --user, --format | Grant result | Grant study access. |
| study access list | study_access_list | datastore-operation | single-study | --format | Access grant list | List study access grants. |
| study access revoke | study_access_revoke | datastore-operation | single-study | --user, --format | Revocation result | Revoke study access. |
| study add | study_add | datastore-operation | no-study | --name, --external-id, --study-type, --domain, optional description, --format | Study registration | Register a study and link it to a domain. |
| study add-domain | study_add_domain | datastore-operation | single-study | --domain, --format | Study registration | Link the current or explicit study to a domain. |
| study clear-current | study_clear_current | session-management | single-study | --format | Text or JSON status | Clear current study from session metadata. |
| study context list | study_context_list | datastore-operation | no-study | --include-unavailable, --format | Study context list | List available study contexts. |
| study current | study_current | session-management | single-study | --format | Text or JSON status | Show the current study. |
| study custodians add-delegate | study_custodians_add | datastore-operation | single-study | user, format, --delegate | Custodian link | Add a delegate custodian. |
| study custodians list | study_custodians_list | datastore-operation | single-study | --format | Custodian list | List study custodians. |
| study custodians remove-delegate | study_custodians_remove | datastore-operation | single-study | user, --format, -delegate | Removal result | Remove a delegate custodian. |
| study custodians transfer-primary | study_custodians_transfer | datastore-operation | single-study | user, --format, -primary | Custodian link | Transfer primary custodianship. |
| study delete <name> | study_delete | datastore-operation | no-study | --reason, optional --actor, --cascade, --force, --archive, --dry-run, --yes, --format | Archive/delete plan or result | Archive by default into the special Archive study, then delete the source study with mandatory lake cleanup. |
| study duo list | study_duo_list | datastore-operation | single-study | --format | DUO restriction list | List study DUO restrictions. |
| study duo replace | study_duo_replace | datastore-operation | single-study | --restrictions, --format | DUO replacement result | Replace the study DUO restriction set. |
| study get <name> | study_get | datastore-operation | no-study | Study name; --format | Study registration | Fetch a study by name. |
| study list | study_list | datastore-operation | no-study | --format text\\|json | Study list | List studies and linked domains. |
| study search | study_search | datastore-operation | no-study | Name/title/description/domain/tag filters; --cursor, --limit, --width, --format | Study search results | Search bounded governed study summaries. |
| study use <name> | study_use | session-management | single-study | Study name | Text status | Set the current study for the active session. |

## Runtime Context Enum

| Value | Meaning |
|---|---|
| local-only | Does not require daemon, session, profile, auth source, datastore, or lake access. |
| diagnostic | Inspects local, configured, session-backed, or automation readiness. |
| auth-management | Creates, inspects, or removes reusable authentication material. |
| session-management | Opens, selects, inspects, reopens, or closes local live datastore sessions. |
| datastore-operation | Requires daemon-backed live session or explicit automation inputs when supported. |

## Study Context Enum

| Value | Meaning |
|---|---|
| not-applicable | The command does not use study context. |
| no-study | Datastore-backed command that does not resolve a study. |
| single-study | Operates in one study, resolved from --study or current session study. |
| study-set | Intentionally operates across an explicit set of studies. |

