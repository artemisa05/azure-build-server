# Azure Build Server

Azure Build Server is a collection of scripts to create an Azure Virtual Machine capable of compiling, testing & deploying .NET applications.

## Prerequisites

- [Azure Subscription](https://azure.com)
- [Azure PowerShell 1.0 or later](https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/)
- [Boxstarter](http://boxstarter.org/)
- [Boxstarter.Azure](https://chocolatey.org/packages?q=boxstarter.azure)

## Usage

`.\config.json`

Edit config.json for your needs.
    
`.\scripts\Initialize-VirtualMachine.ps1 [-VirtualMachinePassword <String>]`

Run New-VirtualMachine.ps1 to create a Windows Server 2012 R2 Datacenter Virtual Machine. The script ends immediatley if the Virtual Machine already exists.
    
-VirtualMachinePassword parameter can be ignored if environment variable VirtualMachinePassword is defined.

`.\scripts\Invoke-WindowsUpdate.ps1 [-VirtualMachinePassword <String>]`

Run Windows Update on the virtual machine.

`.\scripts\Set-Checkpoint.ps1 -Name <String>`

Creates an Azure Blob checkpoint to capture the state of a VM

## Jenkins

Unforunately Jenkins' installation cannot not be fully automatted. Please see .\documentation\installing-jenkins.md.

## Authentication

Access to the Jenkins' website is restricted by Windows authentication. Therefore Jenkins' built in security features are not required.