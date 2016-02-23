$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Write-Host "Running Install-Dependencies02.ps1 @ $env:ComputerName..."

Write-Host "Installing Chocolatey packages..."
& choco install -y webpicmd 