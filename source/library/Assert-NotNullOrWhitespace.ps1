Function Assert-NotNullOrWhitespace(
    [string] $value,

    [ValidateNotNullOrEmpty()]
    [string] $name)
{
    Assert (!([string]::IsNullOrWhitespace($value))) "'$name' cannot be null or whitespace."
}