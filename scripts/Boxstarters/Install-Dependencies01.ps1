$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Write-Host "Running Install-Dependencies01.ps1 @ $env:ComputerName..."

Write-Host "Upgrading Chocolatey packages..."
& choco upgrade all -y

Write-Host "Installing Chocolatey packages..."
& choco install -y carbon chocolatey dotnet4.6.1-devpack git lessmsi microsoft-build-tools nodejs.install notepad2-mod poshgit

. $PSScriptRoot\Remove-ValuesDirectory.ps1