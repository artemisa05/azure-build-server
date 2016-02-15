Function Find-AzureStorageAccount
{
    param(
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Name
    )

    Write-Host "Searching for Azure Storage Account '$Name'..."
    $storageAccount = Invoke-AzureCommand { Get-AzureStorageAccount -StorageAccountName $Name -ErrorAction Continue }

    if ($storageAccount -ne $null)
    {
        Write-Host "Found Azure Storage Account." -ForegroundColor Green
    }
    else
    {
        Write-Host "Cannot find Azure Storage Account." -ForegroundColor Magenta
    }
    
    return $storageAccount
}
