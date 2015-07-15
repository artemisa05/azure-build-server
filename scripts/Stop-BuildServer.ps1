$ErrorActionPreference = "Stop"

$virtualMachineName = "buildservertmit" 
$cloudServiceName = "buildservertmit"

Write-Host "Stopping virtual machine..."
Stop-AzureVM -Name $virtualMachineName -ServiceName $cloudServiceName -Force | Out-Null
Write-Host "Completed successfully." -ForegroundColor Green
