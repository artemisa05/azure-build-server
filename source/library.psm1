# Loads all powershell scripts in .\library folder.

# Resolve-Path $PSScriptRoot\library\*.ps1 | 
Get-ChildItem -Path $PSScriptRoot\library -Filter *.ps1 -Recurse |
    ForEach-Object { 
        Write-Verbose "Loading library file '$($_.Name)'"
        . $_.FullName
    }