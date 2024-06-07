$service = Get-Service -Name ssh-agent -ErrorAction SilentlyContinue
if ($null -eq $service) {
	Write-Output "SSH agent service not found. Make sure OpenSSH is installed."
	return
}
if ($service.Status -ne 'Running') {
	Start-Service ssh-agent
	Write-Output "Started SSH agent service."
}
# Check if the key is already added to the agent.
$keys = ssh-add -L
if ($keys -notmatch "The agent has no identities.") {
	# Do Nothing.
	return
} else {
	ssh-add "$HOME\.ssh\alan_powershell_ssh_key"
	Write-Output "SSH key added to the agent."
}
