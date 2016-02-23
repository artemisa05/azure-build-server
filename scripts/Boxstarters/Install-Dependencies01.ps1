$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Write-Host "Running Install-Dependencies01.ps1 @ $env:ComputerName..."

Write-Host "Upgrading Chocolatey packages..."
& choco upgrade all -y

Write-Host "Installing Chocolatey packages..."
& choco install -y chocolatey git nodejs.install carbon lessmsi notepad2-mod