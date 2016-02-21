$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Write-Host "Running Install-Dependencies.ps1 @ $env:ComputerName..."

Write-Host "Upgrading Chocolatey packages..."
choco upgrade all -y

Write-Host "Installing Chocolatey packages..."
choco install -y chocolatey git nodejs.install carbon dotnet3.5 lessmsi webpicmd notepad2-mod

Write-Host "Installing Microsoft Application Request Routing..."
$lessmsiPath = "C:\ProgramData\chocolatey\bin"

# Ensure lessmsi is in path for webpicmd
if (!$env:Path.Contains($lessmsiPath))
{
    $env:Path = "$lessmsiPath;$env:Path"    
}
&WebPiCmd /install /Products:"ARRv3_0" /AcceptEula
