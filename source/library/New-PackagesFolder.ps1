Function New-PackagesFolder(
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $path)
{
    If (Test-Path $path)
    {
        Write-Host "packages folder '$path' already exists."
    }
    Else
    {
        Write-Host "Creating packages folder '$path'..."
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        Write-Host "Successfully created packages folder '$path'."
    }
}

