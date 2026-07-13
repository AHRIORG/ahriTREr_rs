# TRE Interface vs R Wrapper Gap Analysis

This compares function names from TRE Public Interfaces.csv with currently implemented R functions in this repository.

## Coverage Summary

- Total unique TRE interface functions: 128
- Total unique R functions in wrapper code: 57
- Direct name matches: 0
- Missing TRE functions (direct name comparison): 128

## Category Gap Breakdown

| Category | Interface Functions | Covered (Direct) | Missing |
|---|---:|---:|---:|
| Assets, Datafiles, Datasets | 20 | 0 | 20 |
| Authentication, Daemon, Sessions | 14 | 0 | 14 |
| Datastore, Semantic Catalog | 24 | 0 | 24 |
| Entities, Relations, Transformations, Ingest | 41 | 0 | 41 |
| Local Commands | 5 | 0 | 5 |
| Runtime | 5 | 0 | 5 |
| Study, Governance | 19 | 0 | 19 |

## Covered Functions (Direct Match)

- None by direct function-name parity.

## Interpretation

- The current R package focuses on C-ABI runtime/client bridging and contract smoke testing.
- Full TRE control-plane command parity is not yet implemented in R wrappers.

## Implementation Backlog Summary

1. Study/datastore read operations: study_list, study_get, datastore_info, datastore_ping.
2. Asset/dataset read operations: asset_list, asset_get, dataset_list, dataset_metadata, dataset_preview.
3. Session/auth read operations: auth_status, session_status, session_list.
4. Search surfaces: study_search, dataset_search, datafile_search, variable_search.

See docs/tre_r_wrapper_semantic_gap_analysis.md for capability-level mapping and prioritized phases.

