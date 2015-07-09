Function Install-NuGetPackage(
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $nuGetExe,
    
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $nuGetConfig,
    
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $packagesFolder,
    
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $packageId,
    
    [boolean] $excludeVersion = $false,
    [string] $version)
{
    Write-Host "Checking if '$packageId' is installed..."

    $options = "Install $packageId -OutputDirectory ""$packagesFolder"" -ConfigFile ""$nuGetConfig"""

    If ($excludeVersion)
    {
        $options += " -ExcludeVersion"

        If (Test-Path $packagesFolder\$packageId)
        {
            Write-Host "Package '$packageId' is already installed."
            return
        }
    }
    ElseIf (($version -ne $null) -and (Test-Path $packagesFolder\$packageId.$version))
    {
        Write-Host "Package '$packageId' is already installed."
        return
    }

    If ($version -ne $null)
    {
        $options += " -Version $version"
    }

    Invoke-Expression "&""$nuGetExe"" $options"

    If ($LASTEXITCODE -ne 0)
    {
        throw "Installing '$packageId' failed with ERRORLEVEL '$LASTEXITCODE'"
    }
}
