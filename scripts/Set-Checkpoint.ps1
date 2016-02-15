param(
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $Name
)

$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Import-Module Boxstarter.Azure
Import-Module $PSScriptRoot\Library\Library.psm1 -Force

$config = Read-Config

$vm = Get-AzureVM -Name $config.azure.virtualMachine.name -ServiceName $config.azure.service.name
Set-AzureVMCheckpoint -VM $vm -CheckpointName $Name | Out-Null