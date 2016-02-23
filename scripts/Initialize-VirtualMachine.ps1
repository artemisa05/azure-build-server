param(
    # $WindowsAdminPassword cannot be a SecureString because Add-AzureProvisioningConfig in build-tasks.ps1 requires a String.
    [ValidateNotNullOrEmpty()]
    [string] $VirtualMachinePassword = $env:VirtualMachinePassword
)

$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Import-Module Boxstarter.Azure
Import-Module $PSScriptRoot\Library\Library.psm1 -Force
Assert-IsAdministrator

$config = Read-Config

Write-Host "Searching for virtual machine '$($config.azure.virtualMachine.name)'..."
$vm = Get-AzureVM -Name $config.azure.virtualMachine.name -ServiceName $config.azure.service.name

if ($vm -ne $null) {
    
    Write-Host "Searching for checkpoint 'AfterWindowsUpdate'..."
    $checkpoint = Get-AzureVMCheckpoint -VM $vm -CheckpointName "AfterWindowsUpdate" 
}

if ($checkpoint -eq $null) {
    
    Initialize-AzureAffinityGroup -Name $config.azure.affinityGroup.name -Location $config.azure.affinityGroup.location
    Initialize-AzureService -Name $config.azure.service.name -AffinityGroupName $config.azure.affinityGroup.name
    Initialize-AzureStorageAccount -Name $config.azure.storageAccount.name -AffinityGroupName $config.azure.affinityGroup.name
    Set-CurrentStorageAccount -Name $config.azure.storageAccount.name 

    If ((Find-AzureVirtualMachine -Name $config.azure.virtualMachine.name -ServiceName $config.azure.service.name) -eq $null) {

        Write-Host "Creating Azure Virtual Machine '$($config.azure.virtualMachine.name)'..."
        Write-Host

        New-AzureVMConfig -Name $config.azure.virtualMachine.name -InstanceSize $config.azure.virtualMachine.instanceSize -ImageName $config.azure.virtualMachine.imageName |
            Add-AzureProvisioningConfig -Windows -AdminUsername $config.azure.virtualMachine.adminUsername -Password $VirtualMachinePassword |
            Add-AzureDataDisk -CreateNew -DiskSizeInGB 1023 -DiskLabel "DataDisk" -LUN 0 |
            New-AzureVM -ServiceName $config.azure.service.name -AffinityGroup $config.azure.affinityGroup.name -WaitForBoot |
            Out-Null
    }

    Write-Host "Calling Boxstarter to format data disk..."
    . $PSScriptRoot\Invoke-BoxstarterPackage.ps1 .\Boxstarters\Format-DataDisk.ps1

    Write-Host "Configuring Windows..."
    . $PSScriptRoot\Invoke-BoxstarterPackage.ps1 .\Boxstarters\Set-WindowsConfiguration.ps1

    Write-Host "Running Windows Update..."
    . $PSScriptRoot\Invoke-BoxstarterPackage.ps1 .\Boxstarters\Invoke-WindowsUpdate.ps1

    Write-Host "Downloading and installing the certificate created during creation of virtual machine..."
    Install-WinRMCertificateForVM -SubscriptionName $config.azure.subscription.Name -CloudServiceName $config.azure.service.name -Name $config.azure.virtualMachine.name

    Write-Host "Creating checkpoint 'AfterWindowsUpdate'..."
    . $PSScriptRoot\Set-Checkpoint.ps1 AfterWindowsUpdate
    
} else {
    
    Write-Host "Restoring checkpoint 'AfterWindowsUpdate'..."
    Restore-AzureVMCheckpoint -VM $vm -CheckpointName "AfterWindowsUpdate"
}

Write-Host "Getting virtual machine '$($config.azure.virtualMachine.name)'..."
$vm = Get-AzureVM -Name $config.azure.virtualMachine.name -ServiceName $config.azure.service.name

Write-Host "Searching for checkpoint 'AfterInstallDependencies'..."
$checkpoint = Get-AzureVMCheckpoint -VM $vm -CheckpointName "AfterInstallDependencies" 

if ($checkpoint -ne $null) {

    Write-Host "Virtual machine '$($config.azure.virtualMachine.name)' previously initialised."
    exit 0    
}

Write-Host "Installing dependencies..."
. $PSScriptRoot\Invoke-BoxstarterPackage.ps1 .\Boxstarters\Install-Dependencies01.ps1
. $PSScriptRoot\Invoke-BoxstarterPackage.ps1 .\Boxstarters\Install-Dependencies02.ps1
. $PSScriptRoot\Invoke-BoxstarterPackage.ps1 .\Boxstarters\Install-Dependencies03.ps1

Write-Host "Running Windows Update..."
. $PSScriptRoot\Invoke-BoxstarterPackage.ps1 .\Boxstarters\Invoke-WindowsUpdate.ps1

Write-Host "Creating checkpoint 'AfterInstallDependencies'..."
. $PSScriptRoot\Set-Checkpoint.ps1 AfterInstallDependencies

Write-Host
Write-Host "Successfully created Azure Virtual Machine." -ForegroundColor Green