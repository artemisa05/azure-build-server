param(
    [parameter(Mandatory=$false)]
    [string] $CheckpointName
)

$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Import-Module Boxstarter.Azure
Import-Module $PSScriptRoot\Library\Library.psm1 -Force

$config = Read-Config

Write-Host "Getting virtual machine '$($config.azure.virtualMachine.name)'..."
$vm = Get-AzureVM -Name $config.azure.virtualMachine.name -ServiceName $config.azure.service.name

if ($vm -eq $null) {
    throw "Could not find virtual machine '$($config.azure.virtualMachine.name)'..."
}

if ([System.String]::IsNullOrWhitespace($CheckpointName)) {
    Write-Host "Getting checkpoints..."
} else {
    Write-Host "Getting checkpoint '$CheckpointName'..."    
}

Get-AzureVMCheckpoint -VM $vm -CheckpointName $CheckpointName