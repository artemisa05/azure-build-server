$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Write-Host "Running Set-WindowsConfiguration.ps1 @ $env:ComputerName..."

Write-Host "Disabling Internet Explorer Enhanced Security Configuration..."
Disable-InternetExplorerESC

Write-Host "Disabling Server Manager opening at logon..."
$Key = "HKLM:\SOFTWARE\Microsoft\ServerManager"
If (Test-Path $Key)
{  
    Set-ItemProperty -Path $Key -Name "DoNotOpenServerManagerAtLogon" -Value 1
}

Write-Host "Adjusting Windows Explorer options to display hiden files, folders and extensions..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
If (Test-Path -Path $Key)
{  
    Set-ItemProperty $Key Hidden 1  
    Set-ItemProperty $Key HideFileExt 0  
    Set-ItemProperty $Key ShowSuperHidden 0
}

Write-Host "Restarting Windows Explorer..." 
$identity  = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$parts = $identity.Name -split "\\"
$user = @{Domain=$parts[0];Name=$parts[1]}
$explorer = Get-Process -Name explorer -IncludeUserName -ErrorAction SilentlyContinue

If ($explorer -ne $null)
{ 
    $explorer | ? { $_.UserName -eq "$($user.Domain)\$($user.Name)"} | Stop-Process -Force
}

Start-Sleep 1

If (!(Get-Process -Name explorer -ErrorAction SilentlyContinue))
{
    Start-Process -FilePath explorer
}