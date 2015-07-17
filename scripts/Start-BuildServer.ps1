$ErrorActionPreference = "Stop"

$virtualMachineName = "buildservertmit" 
$cloudServiceName = "buildservertmit"

Function Get-VmStatus()
{
    $vm = Get-AzureVM -ServiceName $cloudServiceName -Name $virtualMachineName

    return $vm.Status
}

Write-Host "Starting virtual machine..."
Start-AzureVM -Name $virtualMachineName -ServiceName $cloudServiceName | Out-Null
Write-Host "Started virtual machine, now waiting for status to change to 'ReadyRole'..."

$vmStatus = Get-VmStatus
while ($vmStatus -ne "ReadyRole")
{
    Write-Host "Virtual machine status is '$vmStatus', waiting for 'ReadyRole'..."

    Start-Sleep -Seconds 1
    $vmStatus = Get-VmStatus
}

Write-Host "Completed successfully." -ForegroundColor Green
