$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$schemaPath = Join-Path $root 'docs\tre_schema_map.json'
$namespacePath = Join-Path $root 'NAMESPACE'
$legacyWrappersPath = Join-Path $root 'R\wrappers.R'
$corePath = Join-Path $root 'R\core.R'
$rdPath = Join-Path $root 'man\tre_command_wrappers.Rd'

$json = Get-Content $schemaPath -Raw | ConvertFrom-Json

$rows = @()
foreach ($cat in $json.categories.PSObject.Properties) {
    foreach ($item in $cat.Value) {
        $fn = ($item.function | Out-String).Trim()
        $status = ($item.statusAndPurpose | Out-String).Trim()
        if ($fn -match '^[A-Za-z][A-Za-z0-9_]*$' -and $cat.Name -ne 'Runtime' -and $status -ne '') {
            $rows += [pscustomobject]@{
                Function = $fn
                Command = ($item.command | Out-String).Trim()
                Category = $cat.Name
            }
        }
    }
}
$rows = $rows | Sort-Object Function -Unique

$categoryFileMap = [ordered]@{
    'Assets, Datafiles, Datasets' = 'assets.R'
    'Authentication, Daemon, Sessions' = 'auth_session.R'
    'Datastore, Semantic Catalog' = 'datastore.R'
    'Entities, Relations, Transformations, Ingest' = 'entities.R'
    'Local Commands' = 'local.R'
    'Study, Governance' = 'study.R'
}

$core = New-Object System.Text.StringBuilder
[void]$core.AppendLine('TRE_PROTOCOL_VERSION <- "1.0.0"')
[void]$core.AppendLine('')
[void]$core.AppendLine('new_tre_protocol_request <- function(kind, body = list(), protocol_version = TRE_PROTOCOL_VERSION) {')
[void]$core.AppendLine('  list(')
[void]$core.AppendLine('    protocol_version = protocol_version,')
[void]$core.AppendLine('    kind = kind,')
[void]$core.AppendLine('    body = body %||% list()')
[void]$core.AppendLine('  )')
[void]$core.AppendLine('}')
[void]$core.AppendLine('')
[void]$core.AppendLine('tre_command_call <- function(client, kind, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {')
[void]$core.AppendLine('  body <- if (is.null(.body)) list(...) else .body')
[void]$core.AppendLine('  execute_json(')
[void]$core.AppendLine('    client = client,')
[void]$core.AppendLine('    request = new_tre_protocol_request(')
[void]$core.AppendLine('      kind = kind,')
[void]$core.AppendLine('      body = body,')
[void]$core.AppendLine('      protocol_version = .protocol_version')
[void]$core.AppendLine('    )')
[void]$core.AppendLine('  )')
[void]$core.AppendLine('}')
[void]$core.AppendLine('')
Set-Content -Path $corePath -Value $core.ToString() -Encoding UTF8

foreach ($categoryName in $categoryFileMap.Keys) {
    $categoryRows = $rows | Where-Object { $_.Category -eq $categoryName } | Sort-Object Function
    $categoryPath = Join-Path $root ("R\" + $categoryFileMap[$categoryName])
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine(("# Auto-generated command wrappers for {0}" -f $categoryName))
    [void]$sb.AppendLine('')
    foreach ($row in $categoryRows) {
        $kind = $row.Function -replace '_', '.'
        [void]$sb.AppendLine(('{0} <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {{' -f $row.Function))
        [void]$sb.AppendLine(('  tre_command_call(client, "{0}", ..., .body = .body, .protocol_version = .protocol_version)' -f $kind))
        [void]$sb.AppendLine('}')
        [void]$sb.AppendLine('')
    }
    Set-Content -Path $categoryPath -Value $sb.ToString() -Encoding UTF8
}

if (Test-Path $legacyWrappersPath) {
    Remove-Item -Path $legacyWrappersPath -Force
}

$nsLines = Get-Content $namespacePath
$useDynLib = $nsLines | Where-Object { $_ -like 'useDynLib(*' } | Select-Object -First 1
$currentExports = $nsLines | Where-Object { $_ -match '^export\(' } | ForEach-Object {
    ($_ -replace '^export\(', '') -replace '\)$', ''
}
$allExports = @($currentExports + ($rows | ForEach-Object { $_.Function })) | Sort-Object -Unique
$nextNamespace = @($useDynLib) + ($allExports | ForEach-Object { "export($_)" })
Set-Content -Path $namespacePath -Value ($nextNamespace -join "`n") -Encoding UTF8

$rdb = New-Object System.Text.StringBuilder
[void]$rdb.AppendLine('\name{tre-command-wrappers}')
foreach ($row in ($rows | Sort-Object Function)) {
    [void]$rdb.AppendLine(('\alias{{{0}}}' -f $row.Function))
}
[void]$rdb.AppendLine('\title{Generated TRE Command Wrapper Functions}')
[void]$rdb.AppendLine('\description{')
[void]$rdb.AppendLine('Auto-generated thin wrappers for TRE protocol command kinds. Each function forwards to \code{execute_json()} via \code{tre_command_call()}.')
[void]$rdb.AppendLine('}')
[void]$rdb.AppendLine('\details{')
[void]$rdb.AppendLine('All wrapper functions share this signature: \code{fn(client, ..., .body = NULL, .protocol_version = "1.0.0")}.')
[void]$rdb.AppendLine('\itemize{')
[void]$rdb.AppendLine('  \item \code{client}: an \code{ahri_tre_client} created by \code{AhriTreClient()}.')
[void]$rdb.AppendLine('  \item \code{...}: request body fields encoded as JSON object members.')
[void]$rdb.AppendLine('  \item \code{.body}: explicit body list, used instead of \code{...} when provided.')
[void]$rdb.AppendLine('  \item \code{.protocol_version}: protocol version value for the request envelope.')
[void]$rdb.AppendLine('}')
[void]$rdb.AppendLine('Wrapper protocol kinds are derived by replacing underscores with dots, for example \code{asset_list} to \code{asset.list}.')
[void]$rdb.AppendLine('}')
[void]$rdb.AppendLine('\value{')
[void]$rdb.AppendLine('Each function returns the same structured value as \code{execute_json()}: an \code{ahri_tre_protocol_result} with \code{envelope} and \code{payloads}.')
[void]$rdb.AppendLine('}')
[void]$rdb.AppendLine('\keyword{package}')

Set-Content -Path $rdPath -Value $rdb.ToString() -Encoding UTF8

Write-Output "WROTE wrappers: $($rows.Count)"
Write-Output "WROTE file: $corePath"
foreach ($name in $categoryFileMap.Values) {
    Write-Output ("WROTE file: " + (Join-Path $root ("R\\" + $name)))
}
if (-not (Test-Path $legacyWrappersPath)) {
    Write-Output "REMOVED file: $legacyWrappersPath"
}
Write-Output "WROTE file: $namespacePath"
Write-Output "WROTE file: $rdPath"