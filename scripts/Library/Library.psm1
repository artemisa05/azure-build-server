# Loads all powershell scripts in this folder.

Get-ChildItem -Path $PSScriptRoot -Filter *.ps1 -Recurse |
    ForEach-Object { 
        Write-Verbose "Loading library file '$($_.Name)'"
        . $_.FullName
    }