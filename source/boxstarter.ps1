Function Main()
{
    Enable-MicrosoftUpdate
    Install-WindowsUpdate -AcceptEula

    Install-Packages
    
    Write-Host "Importing Carbon module..."
    & "C:\Program Files\WindowsPowerShell\Modules\Carbon\Import-Carbon.ps1"

    Configure-Windows
    # Configure-Path
    Install-ReverseProxyServer

    Write-Host
    Install-WindowsUpdate -AcceptEula
}

Function Configure-Path()
{
    Write-Host 
    Write-Host "Configuring PATH..."
    Write-Host "----------------------------------------------------------------------"
    
    $userPath = [environment]::GetEnvironmentVariable("Path", "User");
    $machinePath = [environment]::GetEnvironmentVariable("Path", "Machine");
    $npmPath = "C:\Windows\System32\config\systemprofile\AppData\Roaming\npm;"
    
    $userPath = $userPath.Trim(";") + ";"
    $machinePath = $machinePath.Trim(";") + ";"
    
    if (-not $machinePath.Contains($npmPath))
    {
        $machinePath += $npmPath
        [Environment]::SetEnvironmentVariable("Path", $machinePath, "Machine")
    }

    if (-not $userPath.Contains($npmPath))
    {
        $userPath += $npmPath
        [Environment]::SetEnvironmentVariable("Path", $userPath, "User")
    }
}

Function Install-Packages()
{
    choco update -y all
    
    choco install -y boxstarter
    choco install -y carbon
    choco install -y dotnet3.5 # required by webpicmd
    choco install -y git
    choco install -y jenkins
    choco install -y microsoft-build-tools
    choco install -y nodejs
    choco install -y webpicmd # requires dotnet3.5

    npm install -g rimraf
    npm install -g bower
    npm install -g gulp

    &WebPiCmd /install /Products:"ARRv3_0" /AcceptEula
    Install-WindowsUpdate -AcceptEula
}

Function Configure-Windows()
{
    Write-Host "Disabling Internet Explorer Enhanced Security Configuration..."
    Disable-InternetExplorerESC

    Write-Host "Disabling Server Manager opening at logon..."
    $Key = "HKLM:\SOFTWARE\Microsoft\ServerManager"
    if(Test-Path $Key)
    {  
        Set-ItemProperty -Path $Key -Name "DoNotOpenServerManagerAtLogon" -Value 1
    }
 
    Write-Host "Adjusting Windows Explorer options to display hiden files, folders and extensions..."
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    if(Test-Path -Path $Key) {  
        Set-ItemProperty $Key Hidden 1  
        Set-ItemProperty $Key HideFileExt 0  
        Set-ItemProperty $Key ShowSuperHidden 0
    }

    Write-Host "Restarting Windows Explorer..." 
    $identity  = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $parts = $identity.Name -split "\\"
    $user = @{Domain=$parts[0];Name=$parts[1]}
    $explorer = Get-Process -Name explorer -IncludeUserName -ErrorAction SilentlyContinue
   
    if($explorer -ne $null) { 
        $explorer | ? { $_.UserName -eq "$($user.Domain)\$($user.Name)"} | Stop-Process -Force
    }
 
    Start-Sleep 1
 
    if(!(Get-Process -Name explorer -ErrorAction SilentlyContinue)) {
        start-Process -FilePath explorer
    }
}

Function Install-ReverseProxyServer()
{
    Write-Host "Installing web server..."
    Install-WindowsFeature -Name Web-Server | Out-Null

    Write-Host "Installing IIS Basic Authentication..."
    Install-WindowsFeature -Name Web-Basic-Auth | Out-Null

    # Required to rerouting the Jenkins server.
    Write-Host "Enabling Application Request Routing proxy..."
    Set-WebConfigurationProperty system.webServer/proxy -Name enabled -Value "True"

    Create-Directory "C:\Websites"

    Write-Host "Removing existing websites..."
    Get-Website | ForEach-Object { Delete-Website -name $_.Name }

    Write-Host "Search for default certificate..."
    $defaultCertificateSubject = "CN=$($env:COMPUTERNAME.ToLower()).cloudapp.net"
    $defaultCertificate = Get-Certificate -Path Cert:\LocalMachine\My\* | Where-Object { $_.Subject -eq $defaultCertificateSubject }

    if ($defaultCertificateSubject -eq $null)
    {
        throw "Cannot find default certificate '$defaultCertificateSubject'."
    }

    $websiteName = "Jenkins Proxy"
    $physicalPath = "C:\Websites\JenkinsProxy"
    $applicationId = [Guid]::NewGuid()

    Write-Host "Creating '$websiteName' website..."
    Create-Directory $physicalPath
    New-Website -Id 2 -Name $websiteName -PhysicalPath $physicalPath -IPAddress "*" -Ssl -Port 443 -HostHeader "buildservertmit.cloudapp.net" | Out-Null

    Write-Host "Downloading Web.config to '$websiteName' website..."
    $webclient = New-Object System.Net.WebClient
    $url = "https://github.com/TimMurphy/azure-build-server/blob/master/source/reverse-proxy-web.config"
    $file = "$physicalPath\Web.config"
    $webclient.DownloadFile($url, $file)

    Write-Host "Enabling SSL for'$websiteName' website..."
    Enable-IisSsl -SiteName $websiteName -RequireSsl | Out-Null

    Write-Host "Setting certificate for '$websiteName' website..."
    Set-IisWebsiteSslCertificate -SiteName $websiteName -Thumbprint $defaultCertificate.Thumbprint -ApplicationID $applicationId

    Write-Host "Enabling Basic authentication for '$websiteName' website..."
    Disable-IisSecurityAuthentication -SiteName $websiteName -Anonymous
    Enable-IisSecurityAuthentication -SiteName $websiteName -Basic
    Disable-IisSecurityAuthentication -SiteName $websiteName -Windows

    Get-Website -Name $websiteName
}

Function Create-Directory($directory)
{
    If (-not (Test-Path $directory))
    {
        Write-Host "Creating '$directory' directory..."
        New-Item -Path $directory -ItemType Directory | Out-Null
    }
}

Function Delete-Website($name)
{
    if ((Get-Website -Name $name) -ne $null)
    {
        Write-Host "Removing '$name' website..."
        Remove-Website -Name $name
    }
}

Main
