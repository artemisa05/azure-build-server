Function New-WindowsCredentials(
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $UserName,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $ClearPassword)
{
    $securePassword = ConvertTo-SecureString -String $ClearPassword -AsPlainText -Force
    $credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $securePassword

    return $credentials
}