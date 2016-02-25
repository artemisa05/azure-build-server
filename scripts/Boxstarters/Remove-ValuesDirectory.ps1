$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

$directory = "$PSScriptRoot\Resources\Values"

if (Test-Path $directory) {
    Write-Host "Deleting directory '$directory'..."
    Remove-Item $directory -Recurse -Force    
}

$path = "$env:UserProfiles\AppData\Local\Temp\boxstarter\BuildPackages\temp_AzureBuildServer.1.0.0.nupkg"

if (Test-Path $path) {
    Write-Host "Deleting boxstarter package '$path'..."
    Remove-Item $path    
}