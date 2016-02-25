Function Set-CurrentStorageAccount {
    param(
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Name
    )

    Write-Host "Setting current storage account to '$Name'..."

    $currentAzureSubscription = Get-AzureSubscription | Where-Object { $_.IsCurrent }

    Set-AzureSubscription -SubscriptionName $currentAzureSubscription.SubscriptionName -CurrentStorageAccountName $Name
}