$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Write-Host "Running Boxstarter-WindowsUpdate.ps1 @ $env:ComputerName..."

Enable-MicrosoftUpdate
Install-WindowsUpdate -AcceptEula

. $PSScriptRoot\Remove-ValuesDirectory.ps1