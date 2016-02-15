Function Initialize-AzureService
{
    param(
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $AffinityGroupName
    )

    $azureService = Find-AzureService -serviceName $Name

    if ($azureService -ne $null)
    {
        return
    }

    Write-Host "Creating Azure Service '$($Name)'..."
    New-AzureService -ServiceName $Name -affinityGroup $AffinityGroupName | Out-Null
    Write-Host "Successfully created Azure Service." -ForegroundColor Green
}