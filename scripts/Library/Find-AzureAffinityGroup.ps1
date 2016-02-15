Function Find-AzureAffinityGroup
{
    param(
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Name
    )

    Write-Host "Searching for Azure Affinity Group '$Name'..."
    $affinityGroup = Invoke-AzureCommand { Get-AzureAffinityGroup -Name $Name -ErrorAction Continue }

    if ($affinityGroup -ne $null)
    {
        Write-Host "Found Azure Affinity Group." -ForegroundColor Green
    }
    else
    {
        Write-Host "Cannot find Azure Affinity Group." -ForegroundColor Magenta
    }
    
    return $affinityGroup
}
