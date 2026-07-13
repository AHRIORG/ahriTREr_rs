$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$csvPath = "C:\Users\Njabulo.Myeza\OneDrive - AHRI\Documents\Work\AHRI\Projects\TRE\docs\TRE Public Interfaces.csv"
$docsDir = Join-Path $root "docs"

$rows = Import-Csv -Path $csvPath -Delimiter ';' -Header @('Command','Function','Category','RuntimeContext','StudyContext','ImportantInputs','Output','StatusAndPurpose')
$data = $rows | Where-Object {
    $_.Command -and $_.Function -and $_.Category -and
    $_.Command -ne 'Command' -and $_.Function -ne 'Function' -and $_.Category -ne 'Category'
} | ForEach-Object {
    [pscustomobject]@{
        Command = $_.Command.Trim()
        Function = $_.Function.Trim()
        Category = $_.Category.Trim()
        RuntimeContext = (($_.RuntimeContext | Out-String).Trim())
        StudyContext = (($_.StudyContext | Out-String).Trim())
        ImportantInputs = (($_.ImportantInputs | Out-String).Trim())
        Output = (($_.Output | Out-String).Trim())
        StatusAndPurpose = (($_.StatusAndPurpose | Out-String).Trim())
    }
}

$runtimeEnums = @(
    [pscustomobject]@{ value='local-only'; meaning='Does not require daemon, session, profile, auth source, datastore, or lake access.' },
    [pscustomobject]@{ value='diagnostic'; meaning='Inspects local, configured, session-backed, or automation readiness.' },
    [pscustomobject]@{ value='auth-management'; meaning='Creates, inspects, or removes reusable authentication material.' },
    [pscustomobject]@{ value='session-management'; meaning='Opens, selects, inspects, reopens, or closes local live datastore sessions.' },
    [pscustomobject]@{ value='datastore-operation'; meaning='Requires daemon-backed live session or explicit automation inputs when supported.' }
)
$studyEnums = @(
    [pscustomobject]@{ value='not-applicable'; meaning='The command does not use study context.' },
    [pscustomobject]@{ value='no-study'; meaning='Datastore-backed command that does not resolve a study.' },
    [pscustomobject]@{ value='single-study'; meaning='Operates in one study, resolved from --study or current session study.' },
    [pscustomobject]@{ value='study-set'; meaning='Intentionally operates across an explicit set of studies.' }
)

$grouped = $data | Group-Object Category | Sort-Object Name

$mdPath = Join-Path $docsDir 'tre_command_reference.md'
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('# TRE Public Command Reference')
[void]$sb.AppendLine()
[void]$sb.AppendLine('Generated from TRE Public Interfaces.csv. Grouped by category.')
[void]$sb.AppendLine()
foreach ($g in $grouped) {
    [void]$sb.AppendLine("## $($g.Name)")
    [void]$sb.AppendLine()
    [void]$sb.AppendLine('| Command | Function | Runtime Context | Study Context | Important Inputs | Output | Status and Purpose |')
    [void]$sb.AppendLine('|---|---|---|---|---|---|---|')
    foreach ($r in ($g.Group | Sort-Object Command, Function)) {
        $vals = @($r.Command,$r.Function,$r.RuntimeContext,$r.StudyContext,$r.ImportantInputs,$r.Output,$r.StatusAndPurpose) | ForEach-Object {
            ($_ -replace '\|','\\|' -replace "`r|`n", ' ').Trim()
        }
        [void]$sb.AppendLine('| ' + ($vals -join ' | ') + ' |')
    }
    [void]$sb.AppendLine()
}
[void]$sb.AppendLine('## Runtime Context Enum')
[void]$sb.AppendLine()
[void]$sb.AppendLine('| Value | Meaning |')
[void]$sb.AppendLine('|---|---|')
foreach ($e in $runtimeEnums) { [void]$sb.AppendLine("| $($e.value) | $($e.meaning) |") }
[void]$sb.AppendLine()
[void]$sb.AppendLine('## Study Context Enum')
[void]$sb.AppendLine()
[void]$sb.AppendLine('| Value | Meaning |')
[void]$sb.AppendLine('|---|---|')
foreach ($e in $studyEnums) { [void]$sb.AppendLine("| $($e.value) | $($e.meaning) |") }
Set-Content -Path $mdPath -Value $sb.ToString() -Encoding UTF8

$jsonPath = Join-Path $docsDir 'tre_schema_map.json'
$categories = [ordered]@{}
foreach ($g in $grouped) {
    $categories[$g.Name] = @(
        $g.Group | Sort-Object Command, Function | ForEach-Object {
            [ordered]@{
                command = $_.Command
                function = $_.Function
                category = $_.Category
                runtimeContext = $_.RuntimeContext
                studyContext = $_.StudyContext
                importantInputs = $_.ImportantInputs
                output = $_.Output
                statusAndPurpose = $_.StatusAndPurpose
            }
        }
    )
}
$jsonObj = [ordered]@{
    schemaVersion = '1.0.0'
    generatedAtUtc = (Get-Date).ToUniversalTime().ToString('o')
    source = $csvPath
    counts = [ordered]@{ categories = $grouped.Count; interfaces = $data.Count }
    enums = [ordered]@{ runtimeContext = $runtimeEnums; studyContext = $studyEnums }
    categories = $categories
}
($jsonObj | ConvertTo-Json -Depth 8) | Set-Content -Path $jsonPath -Encoding UTF8

$rFiles = Get-ChildItem -Path (Join-Path $root 'R') -Filter '*.R' -File
$rFunctions = foreach ($f in $rFiles) {
    $content = Get-Content -Path $f.FullName
    foreach ($line in $content) {
        if ($line -match '^([A-Za-z0-9_\.]+)\s*<-\s*function\s*\(') {
            [pscustomobject]@{ Name = $matches[1]; File = $f.Name }
        }
    }
}
$rNames = $rFunctions.Name | Sort-Object -Unique
$apiFunctions = $data.Function | Sort-Object -Unique
$directMatches = $apiFunctions | Where-Object { $rNames -contains $_ }

$gapPath = Join-Path $docsDir 'tre_r_wrapper_gap_analysis.md'
$gb = New-Object System.Text.StringBuilder
[void]$gb.AppendLine('# TRE Interface vs R Wrapper Gap Analysis')
[void]$gb.AppendLine()
[void]$gb.AppendLine('This compares function names from TRE Public Interfaces.csv with currently implemented R functions in this repository.')
[void]$gb.AppendLine()
[void]$gb.AppendLine('## Coverage Summary')
[void]$gb.AppendLine()
[void]$gb.AppendLine("- Total unique TRE interface functions: $($apiFunctions.Count)")
[void]$gb.AppendLine("- Total unique R functions in wrapper code: $($rNames.Count)")
[void]$gb.AppendLine("- Direct name matches: $($directMatches.Count)")
[void]$gb.AppendLine("- Missing TRE functions (direct name comparison): $($apiFunctions.Count - $directMatches.Count)")
[void]$gb.AppendLine()
[void]$gb.AppendLine('## Category Gap Breakdown')
[void]$gb.AppendLine()
[void]$gb.AppendLine('| Category | Interface Functions | Covered (Direct) | Missing |')
[void]$gb.AppendLine('|---|---:|---:|---:|')
foreach ($g in $grouped) {
    $fn = $g.Group.Function | Sort-Object -Unique
    $cov = ($fn | Where-Object { $rNames -contains $_ }).Count
    $cnt = $fn.Count
    [void]$gb.AppendLine("| $($g.Name) | $cnt | $cov | $($cnt - $cov) |")
}
[void]$gb.AppendLine()
[void]$gb.AppendLine('## Covered Functions (Direct Match)')
[void]$gb.AppendLine()
if ($directMatches.Count -eq 0) {
    [void]$gb.AppendLine('- None by direct function-name parity.')
} else {
    foreach ($m in $directMatches) { [void]$gb.AppendLine("- $m") }
}
[void]$gb.AppendLine()
[void]$gb.AppendLine('## Interpretation')
[void]$gb.AppendLine()
[void]$gb.AppendLine('- The current R package focuses on C-ABI runtime/client bridging and contract smoke testing.')
[void]$gb.AppendLine('- Full TRE control-plane command parity is not yet implemented in R wrappers.')
[void]$gb.AppendLine()
[void]$gb.AppendLine('## Implementation Backlog Summary')
[void]$gb.AppendLine()
[void]$gb.AppendLine('1. Study/datastore read operations: study_list, study_get, datastore_info, datastore_ping.')
[void]$gb.AppendLine('2. Asset/dataset read operations: asset_list, asset_get, dataset_list, dataset_metadata, dataset_preview.')
[void]$gb.AppendLine('3. Session/auth read operations: auth_status, session_status, session_list.')
[void]$gb.AppendLine('4. Search surfaces: study_search, dataset_search, datafile_search, variable_search.')
[void]$gb.AppendLine()
[void]$gb.AppendLine('See docs/tre_r_wrapper_semantic_gap_analysis.md for capability-level mapping and prioritized phases.')
Set-Content -Path $gapPath -Value $gb.ToString() -Encoding UTF8

# Semantic coverage analysis (capability-level mapping, not strict name equality)
$semanticPath = Join-Path $docsDir 'tre_r_wrapper_semantic_gap_analysis.md'
$sb2 = New-Object System.Text.StringBuilder
[void]$sb2.AppendLine('# TRE Interface vs R Wrapper Semantic Gap Analysis')
[void]$sb2.AppendLine()
[void]$sb2.AppendLine('This report maps TRE command capabilities to current R wrapper capabilities by behavior rather than strict function-name parity.')
[void]$sb2.AppendLine()
[void]$sb2.AppendLine('## Current R Capability Surface')
[void]$sb2.AppendLine()
[void]$sb2.AppendLine('- Runtime artifact discovery and ABI loading: `discover_runtime_artifact`, `CApi`.')
[void]$sb2.AppendLine('- Runtime lifecycle actions: `runtime_status`, `runtime_discover_daemon_binary`, `runtime_ensure`, `runtime_stop`.')
[void]$sb2.AppendLine('- Protocol execution transport: `AhriTreClient`, `execute_json`.')
[void]$sb2.AppendLine('- Payload extraction and Arrow conversion: `payloads_from_result`, `arrow_ipc_to_table`.')
[void]$sb2.AppendLine('- Contract smoke orchestration and redaction: `run_contract_smoke`, `redact_diagnostics`.')
[void]$sb2.AppendLine()

$categoryCoverage = [ordered]@{
    'Assets, Datafiles, Datasets' = 'No command-specific wrappers. Potentially reachable via generic protocol transport (`execute_json`) when request envelopes are authored manually.'
    'Study, Governance' = 'No command-specific wrappers. No direct study-governance helper surface yet.'
    'Datastore, Semantic Catalog' = 'No command-specific wrappers. No direct datastore/domain/variable/vocabulary helpers yet.'
    'Authentication, Daemon, Sessions' = 'Partial semantic overlap via runtime lifecycle wrappers (status/ensure/stop), but no auth/session command wrappers.'
    'Entities, Relations, Transformations, Ingest' = 'No command-specific wrappers. No semantic catalog instance helper layer yet.'
    'Local Commands' = 'No direct wrappers for version/doctor/schema/completion command set.'
    'Runtime' = 'Substantial semantic overlap via local runtime and lifecycle wrappers.'
}

[void]$sb2.AppendLine('## Category-Level Semantic Coverage')
[void]$sb2.AppendLine()
[void]$sb2.AppendLine('| Category | Semantic Coverage |')
[void]$sb2.AppendLine('|---|---|')
foreach ($k in $categoryCoverage.Keys) {
    [void]$sb2.AppendLine("| $k | $($categoryCoverage[$k]) |")
}
[void]$sb2.AppendLine()

[void]$sb2.AppendLine('## Prioritized Implementation Phases')
[void]$sb2.AppendLine()
[void]$sb2.AppendLine('1. Phase 1 (read-only governance/datastore): `study_list`, `study_get`, `datastore_info`, `datastore_ping`.')
[void]$sb2.AppendLine('2. Phase 2 (read-only assets/datasets): `asset_list`, `asset_get`, `dataset_list`, `dataset_metadata`, `dataset_preview`.')
[void]$sb2.AppendLine('3. Phase 3 (auth/session diagnostics): `auth_status`, `session_status`, `session_list`.')
[void]$sb2.AppendLine('4. Phase 4 (search APIs): `study_search`, `dataset_search`, `datafile_search`, `variable_search`.')
[void]$sb2.AppendLine('5. Phase 5 (mutation APIs): grants/revoke, create/delete, ingest/materialization with explicit safety flags and dry-run support.')
[void]$sb2.AppendLine()

[void]$sb2.AppendLine('## Design Notes for Wrapper Expansion')
[void]$sb2.AppendLine()
[void]$sb2.AppendLine('- Keep transport (`execute_json`) separate from typed command wrappers.')
[void]$sb2.AppendLine('- Add typed request builders and response normalizers per category.')
[void]$sb2.AppendLine('- Preserve dry-run/force/yes semantics for destructive operations.')
[void]$sb2.AppendLine('- Standardize error mapping to `ahri_tre_error` subclasses by command family.')
Set-Content -Path $semanticPath -Value $sb2.ToString() -Encoding UTF8

Write-Output "WROTE: $mdPath"
Write-Output "WROTE: $jsonPath"
Write-Output "WROTE: $gapPath"
Write-Output "WROTE: $semanticPath"
Write-Output "COUNTS: categories=$($grouped.Count), interfaces=$($data.Count), apiFunctions=$($apiFunctions.Count), directMatches=$($directMatches.Count)"
