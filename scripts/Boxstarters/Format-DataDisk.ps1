$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Write-Host "Running Format-DataDisk.ps1 @ $env:ComputerName..."

Get-Disk |
    Where PartitionStyle -eq 'raw' |
    Initialize-Disk -PartitionStyle MBR -PassThru |
    New-Partition -AssignDriveLetter -UseMaximumSize |
    Format-Volume -FileSystem NTFS -NewFileSystemLabel "DataDisk" -Confirm:$false

. $PSScriptRoot\Remove-ValuesDirectory.ps1