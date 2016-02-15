Function Find-AzureService()
{
    param(
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $ServiceName
    )

    Write-Host "Searching for Azure Service '$ServiceName'..."
    $service = Invoke-AzureCommand { Get-AzureService -ServiceName $ServiceName -ErrorAction Continue }

    if ($service -ne $null)
    {
        Write-Host "Found Azure Service." -ForegroundColor Green
    }
    else
    {
        Write-Host "Cannot find Azure Service." -ForegroundColor Magenta
    }

    return $service
}
