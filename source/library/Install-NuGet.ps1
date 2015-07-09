Function Install-NuGet(
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $path)
{

    If (Test-Path $path)
    {
        Write-Host "NuGet.exe is already installed."
        return
    }

    Write-Host "Installating NuGet.exe..."
    Invoke-WebRequest http://www.nuget.org/NuGet.exe -OutFile $path
    Write-Host "Successfully installed NuGet."
}

