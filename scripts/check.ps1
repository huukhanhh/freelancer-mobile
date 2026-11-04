$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path -Parent $PSScriptRoot
$taskFlutter = Join-Path $taskRoot '.tools\flutter\bin\flutter.bat'
$taskDart = Join-Path $taskRoot '.tools\flutter\bin\dart.bat'
if (-not (Test-Path -LiteralPath $taskFlutter)) {
    $taskFlutterCommand = Get-Command flutter -ErrorAction SilentlyContinue
    $taskDartCommand = Get-Command dart -ErrorAction SilentlyContinue
    if (-not $taskFlutterCommand -or -not $taskDartCommand) {
        throw 'Flutter/Dart SDK missing. See README.md.'
    }
    $taskFlutter = $taskFlutterCommand.Source
    $taskDart = $taskDartCommand.Source
}
Push-Location -LiteralPath $taskRoot
try {
    & $taskDart format --output=none --set-exit-if-changed lib test
    if ($LASTEXITCODE -ne 0) { throw 'dart format failed.' }
    & $taskFlutter analyze --no-pub
    if ($LASTEXITCODE -ne 0) { throw 'flutter analyze failed.' }
    & $taskFlutter test --no-pub
    if ($LASTEXITCODE -ne 0) { throw 'flutter test failed.' }
} finally {
    Pop-Location
}
