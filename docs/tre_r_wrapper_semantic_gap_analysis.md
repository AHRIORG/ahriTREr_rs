# TRE Interface vs R Wrapper Semantic Gap Analysis

This report maps TRE command capabilities to current R wrapper capabilities by behavior rather than strict function-name parity.

## Current R Capability Surface

- Runtime artifact discovery and ABI loading: `discover_runtime_artifact`, `CApi`.
- Runtime lifecycle actions: `runtime_status`, `runtime_discover_daemon_binary`, `runtime_ensure`, `runtime_stop`.
- Protocol execution transport: `AhriTreClient`, `execute_json`.
- Payload extraction and Arrow conversion: `payloads_from_result`, `arrow_ipc_to_table`.
- Contract smoke orchestration and redaction: `run_contract_smoke`, `redact_diagnostics`.

## Category-Level Semantic Coverage

| Category | Semantic Coverage |
|---|---|
| Assets, Datafiles, Datasets | No command-specific wrappers. Potentially reachable via generic protocol transport (`execute_json`) when request envelopes are authored manually. |
| Study, Governance | No command-specific wrappers. No direct study-governance helper surface yet. |
| Datastore, Semantic Catalog | No command-specific wrappers. No direct datastore/domain/variable/vocabulary helpers yet. |
| Authentication, Daemon, Sessions | Partial semantic overlap via runtime lifecycle wrappers (status/ensure/stop), but no auth/session command wrappers. |
| Entities, Relations, Transformations, Ingest | No command-specific wrappers. No semantic catalog instance helper layer yet. |
| Local Commands | No direct wrappers for version/doctor/schema/completion command set. |
| Runtime | Substantial semantic overlap via local runtime and lifecycle wrappers. |

## Prioritized Implementation Phases

1. Phase 1 (read-only governance/datastore): `study_list`, `study_get`, `datastore_info`, `datastore_ping`.
2. Phase 2 (read-only assets/datasets): `asset_list`, `asset_get`, `dataset_list`, `dataset_metadata`, `dataset_preview`.
3. Phase 3 (auth/session diagnostics): `auth_status`, `session_status`, `session_list`.
4. Phase 4 (search APIs): `study_search`, `dataset_search`, `datafile_search`, `variable_search`.
5. Phase 5 (mutation APIs): grants/revoke, create/delete, ingest/materialization with explicit safety flags and dry-run support.

## Design Notes for Wrapper Expansion

- Keep transport (`execute_json`) separate from typed command wrappers.
- Add typed request builders and response normalizers per category.
- Preserve dry-run/force/yes semantics for destructive operations.
- Standardize error mapping to `ahri_tre_error` subclasses by command family.

