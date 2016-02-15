param(
    [ValidateNotNullOrEmpty()]
    [string] $VirtualMachinePassword = $env:VirtualMachinePassword
)

$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Import-Module $PSScriptRoot\Library\Library.psm1 -Force

$config = Read-Config
$uri = Get-AzureWinRMUri -ServiceName $config.azure.service.name -Name $config.azure.virtualMachine.name
$credentials = New-WindowsCredentials -UserName $config.azure.virtualMachine.adminUserName -ClearPassword $VirtualMachinePassword
Enter-PSSession -ConnectionUri $uri -Credential $credentials