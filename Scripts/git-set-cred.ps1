param (
	[string]$localUsername,
	[string]$localEmail
)

# Check if the current directory is a Git repo.
if (-not (Test-Path .git)){
	Write-Host "The current path is not a Git repository."
	return
}
# If the user has not entered credentials, prompt them too.
if (-not $localUsername) {
	$localUsername = Read-Host "Enter your local Git username: "
}
if (-not $localEmail) {
	$localEmail = Read-Host "Enter your local Git email: "
}
# Officially set those credentials for the current working directories repository.
git config --local user.name "$localUsername"
git config --local user.email "$localEmail"
Write-Host "Local Git credentials set for current repository: $localUsername <$localEmail>"

