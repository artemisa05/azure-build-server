Function Initialize-AzureStorageAccount
{
    param(
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $Name,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $AffinityGroupName
    )

    if ((Find-AzureStorageAccount -Name $Name) -ne $null)
    {
        return
    }

    Write-Host "Creating Azure Storage Account '$Name'..."
    New-AzureStorageAccount -StorageAccountName $Name -AffinityGroup $AffinityGroupName | Out-Null
    Write-Host "Successfully created Azure Storage Account." -ForegroundColor Green
}
