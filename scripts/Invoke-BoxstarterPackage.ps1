param(
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $Name,

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [string] $VirtualMachinePassword = $env:VirtualMachinePassword
)

Write-Host "Invoking Boxstarter..."

$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Import-Module Boxstarter.Azure
Import-Module $PSScriptRoot\Library\Library.psm1 -Force

$config = Read-Config
$credentials = New-WindowsCredentials -UserName $config.azure.virtualMachine.adminUsername -ClearPassword $VirtualMachinePassword

$packageName = "temp_AzureBuildServer"
$packageDirectory = [System.IO.Path]::Combine($Boxstarter.LocalRepo, $packageName)
$chocolateyInstallPath = [System.IO.Path]::Combine($packageDirectory, "tools\ChocolateyInstall.ps1")
$scriptsDirectory = $(Resolve-Path $PSScriptRoot\..\scripts)
$callFileName = [System.IO.Path]::GetFileName($Name)
$chocolateyInstallContent = ". $" + "PSScriptRoot\..\scripts\Boxstarters\$callFileName"

if (Test-Path $packageDirectory) {
    Write-Host "Removing existing Boxstarter package..."
    Remove-Item $packageDirectory -Recurse
}

Write-Host "Creating Boxstarter package..."
New-BoxstarterPackage -Name $packageName -Path $scriptsDirectory
Set-Content -Path $chocolateyInstallPath -Value $chocolateyInstallContent

Write-Host "Building Boxstarter package..."
Invoke-BoxstarterBuild $packageName

Write-Host "Installing boxstarter package '$packageName'..."
$config.azure.virtualMachine.name |
    Enable-BoxstarterVM -Provider Azure -CloudServiceName $config.azure.service.name -Credential $credentials | 
    Install-BoxstarterPackage -PackageName $packageName