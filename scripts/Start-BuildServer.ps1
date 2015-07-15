$ErrorActionPreference = "Stop"

$virtualMachineName = "buildservertmit" 
$cloudServiceName = "buildservertmit"

Write-Host "Starting virtual machine..."
Start-AzureVM -Name $virtualMachineName -ServiceName $cloudServiceName | Out-Null
Write-Host "Completed successfully." -ForegroundColor Green
