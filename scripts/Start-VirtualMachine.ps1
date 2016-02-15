$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Import-Module $PSScriptRoot\Library\Library.psm1 -Force

$config = Read-Config

Function Get-VmStatus()
{
    $vm = Get-AzureVM -ServiceName $config.azure.service.name -Name $config.azure.virtualMachine.name

    return $vm.Status
}

Write-Host "Starting virtual machine..."
Start-AzureVM -Name $config.azure.virtualMachine.name -ServiceName $config.azure.service.name | Out-Null
Write-Host "Started virtual machine, now waiting for status to change to 'ReadyRole'..."

$vmStatus = Get-VmStatus
while ($vmStatus -ne "ReadyRole")
{
    Write-Host "Virtual machine status is '$vmStatus', waiting for 'ReadyRole'..."

    Start-Sleep -Seconds 1
    $vmStatus = Get-VmStatus
}

Write-Host "Completed successfully." -ForegroundColor Green