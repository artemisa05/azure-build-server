Function Initialize-AzureAffinityGroup
{
    param(
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Location
    )

    $affinityGroup = Find-AzureAffinityGroup -Name $Name

    if ($affinityGroup -ne $null)
    {
        return
    }

    Write-Host "Creating Azure Affinity Group '$Name'..."
    New-AzureAffinityGroup -Name $Name -Location $Location
    Write-Host "Successfully created Azure Affinity Group." -ForegroundColor Green
}
