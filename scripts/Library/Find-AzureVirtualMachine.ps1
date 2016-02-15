Function Find-AzureVirtualMachine
{
    param(
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $ServiceName
    )

    Write-Host "Searching for Azure Virtual Machine '$Name'..."
    $virtualMachine = Invoke-AzureCommand { Get-AzureVM -ServiceName $ServiceName -Name $Name -ErrorAction Continue -WarningAction SilentlyContinue }

    if ($virtualMachine -ne $null)
    {
        Write-Host "Found Azure Virtual Machine." -ForegroundColor Green
    }
    else
    {
        Write-Host "Cannot find Azure Virtual Machine." -ForegroundColor Magenta
    }

    return $virtualMachine
}
