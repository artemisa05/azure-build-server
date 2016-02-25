param(
    # $WindowsAdminPassword cannot be a SecureString because Add-AzureProvisioningConfig in build-tasks.ps1 requires a String.
    [ValidateNotNullOrEmpty()]
    [string] $VirtualMachinePassword = $env:VirtualMachinePassword
)

$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Import-Module $PSScriptRoot\Library\Library.psm1 -Force

$config = Read-Config

Write-Host "Adding HTTPS endpoint to '$($config.azure.virtualMachine.name)'..."

Write-Host "Getting virtual machine '$($config.azure.virtualMachine.name)'..."
$vm = Get-AzureVM -Name $config.azure.virtualMachine.name -ServiceName $config.azure.service.name

if ($vm -eq $null) {
    throw "Cannot find virtual machine '$($config.azure.virtualMachine.name)'."
}

Write-Host "Searching for HTTPS enpoint..."
$endpoint = Get-AzureEndpoint -VM $vm -Name "HTTPS"

if ($endpoint -ne $null) {
    
    Write-Host "Endpoint HTTPS already exists on virtual machine '$($config.azure.virtualMachine.name)'..." -ForegroundColor Green
    exit 0
}

Write-Host "Adding HTTPS endpoint..."
Add-AzureEndpoint -Name "HTTPS" -Protocol "tcp" -LocalPort 443 -PublicPort 443 -VM $vm | Update-AzureVM | Out-Null

Write-Host "Successfully added HTTPS endpoint to virtual machine '$($config.azure.virtualMachine.name)'." -ForegroundColor Green