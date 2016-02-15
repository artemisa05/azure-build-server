$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Import-Module $PSScriptRoot\Library\Library.psm1 -Force

$config = Read-Config

Write-Host "Stopping virtual machine..."
Stop-AzureVM -Name $config.azure.virtualMachine.name -ServiceName $config.azure.service.name -Force | Out-Null
Write-Host "Completed successfully." -ForegroundColor Green