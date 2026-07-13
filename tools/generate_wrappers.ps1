$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$schemaPath = Join-Path $root 'docs\tre-schema-map.json'
$namespacePath = Join-Path $root 'NAMESPACE'
$wrappersPath = Join-Path $root 'R\wrappers.R'
$rdPath = Join-Path $root 'man\tre-command-wrappers.Rd'

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
            }
        }
    }
}
$rows = $rows | Sort-Object Function -Unique

$existing = Get-ChildItem (Join-Path $root 'R') -Filter '*.R' | ForEach-Object {
    Select-String -Path $_.FullName -Pattern '^([A-Za-z0-9_\.]+)\s*<-\s*function\s*\(' | ForEach-Object {
        $_.Matches[0].Groups[1].Value
    }
} | Sort-Object -Unique

$outstanding = $rows | Where-Object { $existing -notcontains $_.Function } | Sort-Object Function

$wsb = New-Object System.Text.StringBuilder
[void]$wsb.AppendLine('TRE_PROTOCOL_VERSION <- "1.0.0"')
[void]$wsb.AppendLine('')
[void]$wsb.AppendLine('new_tre_protocol_request <- function(kind, body = list(), protocol_version = TRE_PROTOCOL_VERSION) {')
[void]$wsb.AppendLine('  list(')
[void]$wsb.AppendLine('    protocol_version = protocol_version,')
[void]$wsb.AppendLine('    kind = kind,')
[void]$wsb.AppendLine('    body = body %||% list()')
[void]$wsb.AppendLine('  )')
[void]$wsb.AppendLine('}')
[void]$wsb.AppendLine('')
[void]$wsb.AppendLine('tre_command_call <- function(client, kind, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {')
[void]$wsb.AppendLine('  body <- if (is.null(.body)) list(...) else .body')
[void]$wsb.AppendLine('  execute_json(')
[void]$wsb.AppendLine('    client = client,')
[void]$wsb.AppendLine('    request = new_tre_protocol_request(')
[void]$wsb.AppendLine('      kind = kind,')
[void]$wsb.AppendLine('      body = body,')
[void]$wsb.AppendLine('      protocol_version = .protocol_version')
[void]$wsb.AppendLine('    )')
[void]$wsb.AppendLine('  )')
[void]$wsb.AppendLine('}')
[void]$wsb.AppendLine('')

foreach ($row in $outstanding) {
    $kind = $row.Function -replace '_', '.'
    [void]$wsb.AppendLine(('{0} <- function(client, ..., .body = NULL, .protocol_version = TRE_PROTOCOL_VERSION) {{' -f $row.Function))
    [void]$wsb.AppendLine(('  tre_command_call(client, "{0}", ..., .body = .body, .protocol_version = .protocol_version)' -f $kind))
    [void]$wsb.AppendLine('}')
    [void]$wsb.AppendLine('')
}

Set-Content -Path $wrappersPath -Value $wsb.ToString() -Encoding UTF8

$nsLines = Get-Content $namespacePath
$useDynLib = $nsLines | Where-Object { $_ -like 'useDynLib(*' } | Select-Object -First 1
$currentExports = $nsLines | Where-Object { $_ -match '^export\(' } | ForEach-Object {
    ($_ -replace '^export\(', '') -replace '\)$', ''
}
$allExports = @($currentExports + ($outstanding | ForEach-Object { $_.Function })) | Sort-Object -Unique
$nextNamespace = @($useDynLib) + ($allExports | ForEach-Object { "export($_)" })
Set-Content -Path $namespacePath -Value ($nextNamespace -join "`n") -Encoding UTF8

$rdb = New-Object System.Text.StringBuilder
[void]$rdb.AppendLine('\name{tre-command-wrappers}')
foreach ($row in $outstanding) {
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

Write-Output "WROTE wrappers: $($outstanding.Count)"
Write-Output "WROTE file: $wrappersPath"
Write-Output "WROTE file: $namespacePath"
Write-Output "WROTE file: $rdPath"