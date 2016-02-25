$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Write-Host "Running New-JenkinsUser.ps1 @ $env:ComputerName..."

Remove-Module -Name Carbon -ErrorAction SilentlyContinue
& "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\Carbon\Import-Carbon.ps1"

$userName = "Jenkins"
$groupName = "JenkinsGroup"
$userName = "Jenkins"
$emailAddress = "tim@26tp.com"
$passPharse = '""'
$sshKeyGenPath = "C:\Program Files\Git\usr\bin\ssh-keygen.exe"
$keyDirectory = "c:\Users\$userName\.ssh"
$keyPath = "\$keyDirectory\id_rsa".Replace("\", "/").Replace(":", "")

Write-Host "Getting Jenkins' password..."
$password = $(Get-Content -Path "$PSScriptRoot\Resources\Values\JenkinsPassword.txt").Trim()

Write-Host "Installing user '$userName'..." 
Install-User -Username $userName -FullName "Jenkins CI" -Password $password

Write-Host "Installing group '$groupName'..." 
Install-Group -Name $groupName -Description "Users allowed to access Jenkins"

Write-Host "Adding user '$userName' to group '$groupName'..."
Add-GroupMember -Name $groupName -Member $userName

Write-Host "todo: Add '$groupName' to 'C:\Program Files (x86)\Jenkins' with rights 'Read & execute, List folder contents, Read, Write'" -ForegroundColor Magenta

Write-Host "Generating ssh for '$userName'..."
if (-not (Test-Path $keyDirectory)) {
    New-Item -Path $keyDirectory -ItemType Directory | Out-Null
}
& $sshKeyGenPath -t rsa -b 4096 -C "$emailAddress" -P $passPharse -f $keyPath

. $PSScriptRoot\Remove-ValuesDirectory.ps1