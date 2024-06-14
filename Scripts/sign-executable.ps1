param (
    [string]$PfxFilePath,
    [System.Security.SecureString]$Password,
    [string]$ExecutablePath
)

# Tools needed for signing.
$SigntoolPath = "C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\x64\signtool.exe"
$TimestampUrl = "http://timestamp.digicert.com"

# Signing the executable.
& $SigntoolPath sign /f $PfxFilePath /p $Password /tr $TimestampUrl /td SHA256 /fd SHA256 $ExecutablePath
Write-Host "Executable signed successfully."