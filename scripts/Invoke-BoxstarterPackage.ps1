param(
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $Name,

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [string] $VirtualMachinePassword = $env:VirtualMachinePassword
)

$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Import-Module $PSScriptRoot\Library\Library.psm1 -Force

$config = Read-Config
$credentials = New-WindowsCredentials -UserName $config.azure.virtualMachine.adminUsername -ClearPassword $VirtualMachinePassword

$fileName = [System.IO.Path]::GetFileName($Name)
$packageName = "$($config.boxstarter.baseUrl)/$fileName"

Write-Host "Installing boxstarter package '$packageName'..."
$config.azure.virtualMachine.name |
    Enable-BoxstarterVM -Provider Azure -CloudServiceName $config.azure.service.name -Credential $credentials | 
    Install-BoxstarterPackage -PackageName $packageName