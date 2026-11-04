$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path -Parent $PSScriptRoot
$taskSdk = Join-Path $taskRoot '.tools\flutter\bin\flutter.bat'
if (-not (Test-Path -LiteralPath $taskSdk)) {
    $taskCommand = Get-Command flutter -ErrorAction SilentlyContinue
    if (-not $taskCommand) { throw 'Flutter SDK missing. See README.md.' }
    $taskSdk = $taskCommand.Source
}
Push-Location -LiteralPath $taskRoot
try {
    & $taskSdk @args
    $taskExitCode = $LASTEXITCODE
} finally {
    Pop-Location
}
exit $taskExitCode
