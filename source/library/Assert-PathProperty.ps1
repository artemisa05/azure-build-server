Function Assert-PathProperty(
    [string] $path,

    [ValidateNotNullOrEmpty()]
    [string] $propertyName)
{

    Assert (!([string]::IsNullOrWhitespace($path))) "Property '$propertyName' cannot be null or whitespace."
    Assert (Test-Path $path) "$propertyName '$path' must exist."
}