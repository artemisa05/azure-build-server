$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Write-Host "Running Install-Dependencies03.ps1 @ $env:ComputerName..."

Write-Host "Installing Microsoft Application Request Routing..."
& WebPiCmd /install /Products:"ARRv3_0" /AcceptEula