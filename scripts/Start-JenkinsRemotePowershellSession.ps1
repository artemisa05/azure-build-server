$VirtualMachineUserName = "Jenkins"
$VirtualMachinePassword = $env:JenkinsPassword
$VirtualMachineName = "buildservertmit"

$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Import-Module $PSScriptRoot\Library\Library.psm1 -Force

$config = Read-Config
$uri = Get-AzureWinRMUri -ServiceName $VirtualMachineName -Name $VirtualMachineName
$credentials = New-WindowsCredentials -UserName $VirtualMachineUserName -ClearPassword $VirtualMachinePassword
Enter-PSSession -ConnectionUri $uri -Credential $credentials