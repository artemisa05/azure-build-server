param(
    [parameter(Mandatory=$false)]
    [string[]] $tasks
)

$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

$successful = $false

try
{    
    # Resolve-Path is used to set the following variables so test the files exist.

    $solutionFolder = Resolve-Path $PSScriptRoot\..
    $buildConfig = Resolve-Path $solutionFolder\build.json
    $buildTasks = Resolve-Path $solutionFolder\source\build-tasks.ps1
    $libraryModule = Resolve-Path $solutionFolder\source\library.psm1
    $nuGetConfig = Resolve-Path $solutionFolder\NuGet.config

    # Resolve-Path is not used for the following variables because the file / directory may not exist yet.

    $psakeModule = "$solutionFolder\packages\psake\tools\psake.psm1"
    $packagesFolder = "$solutionFolder\packages"
    $nuGetExe = "$packagesFolder\NuGet.exe"

    Import-Module $libraryModule -Force
    
    $json = Get-Content -Path $buildConfig -Raw
    $config = ConvertFrom-Json -InputObject $json

    if ([string]::IsNullOrWhiteSpace($config.psake.version))
    {
        throw "config.psake.version cannot be null or whitespace."
    }

    New-PackagesFolder -path $packagesFolder
    Install-NuGet -path $nuGetExe
    Install-NuGetPackage -nuGetExe $nuGetExe -nuGetConfig $nuGetConfig -packagesFolder $packagesFolder -PackageId "psake" -ExcludeVersion $true -Version $config.psake.version
    
    Write-Host

    Import-Module $psakeModule -Force
    Invoke-psake $buildTasks -taskList $tasks -properties @{"config" = $config}

    $successful = $psake.build_success
}
catch
{
    Write-Host $_.Exception.Message -ForegroundColor Red
}
finally
{
    Write-Host
    Pop-Location

    if ($successful)
    { 
        Write-Host "Build was successful." -ForegroundColor Green
        exit 0
    }
    else
    {
        Write-Host "Build failed." -ForegroundColor Red
        exit 1
    }
}
