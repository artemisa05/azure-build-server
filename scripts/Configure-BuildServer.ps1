$ErrorActionPreference = "Stop"

$virtualMachineName = "buildservertmit" 
$cloudServiceName = "buildservertmit"
$packageName = "https://gist.githubusercontent.com/TimMurphy/eec664c1c0f2fae2bc91/raw/"
$windowsUserName = "TimMurphy"

if ($credentials -eq $null)
{
    $credentials = Get-Credential -Message "Virtual Machine Credentials" -UserName $windowsUserName
}

Write-Host "Getting virtual machine..."
$vm = Get-AzureVM -ServiceName $cloudServiceName -Name $virtualMachineName

if ($false)
{
    Write-Host "Installing Boxstarter package..."
    $virtualMachineName | 
        Enable-BoxstarterVM -provider Azure -CloudServiceName $cloudServiceName -Credential $credentials | 
        Install-BoxstarterPackage -PackageName $packageName
}

Write-Host "Getting endpoints..."
$endPoints = Get-AzureEndpoint -VM $vm

Write-Host "Testing remote desktop endpoint..."
$endPoint = $endPoints | Where-Object { $_.Name -eq "RemoteDesktop" }

if ($endPoint -eq $null)
{
    throw "Expected to find endpoint for remote desktop."
}

if ($endPoint.Port -ne 55024)
{
    throw "todo: implement changing port number."
}

Write-Host "Testing HTTP endpoint..."
$endPoint = $endPoints | Where-Object { $_.Name -eq "HTTP" }

if ($endPoint -eq $null)
{
    Write-Host "Adding HTTP endpoint..."
    Add-AzureEndpoint -VM $vm -Name "HTTP" -Protocol tcp -LocalPort 80 -PublicPort 80 |
        Update-AzureVM |
        Out-Null
}

Write-Host "Completed successfully." -ForegroundColor Green
