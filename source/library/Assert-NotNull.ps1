Function Assert-NotNull(
    [object] $value,

    [ValidateNotNullOrEmpty()]
    [string] $name)
{
    Assert ($value -ne $null) "'$name' cannot be null."
}