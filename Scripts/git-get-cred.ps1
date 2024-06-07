# Check if the current directory is a Git repository
if (-not (Test-Path .git)) {
	Write-Host "The current path is not a Git repository."
	return
}

# Retrieve the local Git username and email
$localUsername = git config --local user.name
$localEmail = git config --local user.email

if($localUsername -eq $null -and $localEmail -eq $null) {
	Write-Host "No local Git credentials are set for this repository."
} else {
	Write-Host "Local Git credentials for this repository:"
	Write-Host "Username: $localUsername"
	Write-Host "Email: $localEmail"
}
