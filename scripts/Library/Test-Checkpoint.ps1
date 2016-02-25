function Test-Checkpoint {
    param(
        [parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.WindowsAzure.Commands.ServiceManagement.Model.PersistentVMRoleContext] $VM,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $CheckpointName
    )
    Write-Host "Searching for checkpoint '$CheckpointName'..."
    $checkpoint = Get-AzureVMCheckpoint -VM $VM -CheckpointName $CheckpointName 

    return ($checkpoint -ne $null)
}