# Ensure the profile directory exists
$DirectoryPath = Split-Path -Parent $PROFILE
if (!(Test-Path -Path $DirectoryPath)) {
    New-Item -Type Directory -Path $DirectoryPath -Force | Out-Null
}

# Create the profile file if it doesn't exist
if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
}

# Add some initial content to the profile
$profileContent = @"
# PowerShell profile initialization script

# Set the prompt
function prompt {
    "PS $($PWD)> "
}

# Import custom modules
# Import-Module -Name MyCustomModule

# Set aliases
Set-Alias ll Get-ChildItem

# Set environment variables
$env:MY_CUSTOM_VARIABLE = "MyValue"

# Add custom functions
function My-CustomFunction {
    param (
        [string]$name
    )
    Write-Output "Hello, $name!"
}

# Add more customizations below
# ...

"@

# Write the content to the profile
Set-Content -Path $PROFILE -Value $profileContent

Write-Output "PowerShell profile has been initialized."
