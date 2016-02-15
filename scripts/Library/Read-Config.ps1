Function Read-Config()
{
    $configFile = Resolve-Path "$PSScriptRoot\..\..\config.json"
    $json = Get-Content -Path $configFile -Raw
    $config = ConvertFrom-Json -InputObject $json

    return $config
}