param(
    [ValidateNotNullOrEmpty()]
    [string] $VirtualMachinePassword = $env:VirtualMachinePassword,

    [ValidateNotNullOrEmpty()]
    [string] $JenkinsPassword = $env:JenkinsPassword
)

$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Import-Module Boxstarter.Azure
Import-Module $PSScriptRoot\Library\Library.psm1 -Force

$config = Read-Config
$afterInstallDependenciesName = "AfterInstallDependencies"
$afterInstallJenkinsName = "AfterInstallJenkins"

Write-Host "Initializing Jenkins on '$($config.azure.virtualMachine.name)'..."

Write-Host "Searching for virtual machine '$($config.azure.virtualMachine.name)'..."
$vm = Get-AzureVM -Name $config.azure.virtualMachine.name -ServiceName $config.azure.service.name

if ($vm -eq $null) {

    Write-Host "Jenkins cannot be installed until `.\Initialize-VirtualMachien` has completed on '$($config.azure.virtualMachine.name)'."
    exit 0
}

if (Test-Checkpoint -VM $vm -CheckpointName $afterInstallJenkinsName) {

    Write-Host "Jenkins was previously initialised on virtual machine '$($config.azure.virtualMachine.name)'."
    exit 0
}        

if (-not (Test-Checkpoint -VM $vm -CheckpointName $afterInstallDependenciesName)) {

    Write-Host "Jenkins cannot be installed until .\Initialize-VirtualMachien has completed on '$($config.azure.virtualMachine.name)'."
    exit 0
}        

. $PSScriptRoot\Initialize-HttpsEndPoint.ps1

Write-Host "Restoring checkpoint '$afterInstallDependenciesName' on '$($config.azure.virtualMachine.name)'."
Restore-AzureVMCheckpoint -VM $vm -CheckpointName $afterInstallDependenciesName

Write-Host "Adding user 'Jenkins' to '$($config.azure.virtualMachine.name)'..."
. $PSScriptRoot\Invoke-BoxstarterPackage.ps1 .\Boxstarters\New-JenkinsUser.ps1 $VirtualMachinePassword $JenkinsPassword

Write-Host "Installing Jenkins on '$($config.azure.virtualMachine.name)'..."
. $PSScriptRoot\Invoke-BoxstarterPackage.ps1 .\Boxstarters\Install-Jenkins.ps1 $VirtualMachinePassword $JenkinsPassword
  
Write-Host "Running Windows Update..."
. $PSScriptRoot\Invoke-BoxstarterPackage.ps1 .\Boxstarters\Invoke-WindowsUpdate.ps1

Write-Host "Creating checkpoint '$AfterInstallJenkinsName'..."
. $PSScriptRoot\Set-Checkpoint.ps1 $AfterInstallJenkinsName

Write-Host
Write-Host "Successfully created Azure Virtual Machine." -ForegroundColor Green