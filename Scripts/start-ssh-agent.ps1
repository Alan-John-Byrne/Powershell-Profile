# DEFINITION: The OpenSSH toolset: (Authorisation Steps)
# 1. ssh-agent (Background Process): Creates & starts a 'named pipe'
# (e.g: "\\.\pipe\openssh-ssh-agent"), and listens for incoming auth requests
# from other SSH-related tools / processes.
# 2. ssh-add (User Process): Connects to 'ssh-agent' via this named pipe, and
# sends it the private-key which it (ssh-agent) stores in memory for future use.
# 3. ssh (User Process): Checks to see if an SSH agent is available for connecting
# to a remote host (e.g.: ssh -T git@github.com), by sending an authentication
# request to 'ssh-agent' via the # named pipe.
# 4. ssh-agent (Background Process): In response to the 'ssh' auth request, installed
# looks up a suitable stored key (added via 'ssh-add') and returns the corresponding
# signature to 'ssh'.
# 5. ssh (User Process): Uses the signature returned from 'ssh-agent' to authenticate
# with the remote server. If authentication succeeds, access is granted.

$service = Get-Service -Name ssh-agent -ErrorAction SilentlyContinue
if ($null -eq $service)
{
  Write-Output "SSH agent service not found. Make sure OpenSSH is installed."
  return
}
if ($service.Status -ne 'Running')
{
  sudo Start-Service ssh-agent
  Write-Output "Started SSH agent service."
}
# TODO: Specifying the communication pipe to be used by every
# tool within the OpenSSH toolset, during the authentication flow.
$env:SSH_AUTH_SOCK = "\\.\pipe\openssh-ssh-agent"
# Check if the key is already added to the agent. 
$keys = ssh-add -L 2>&1 | Out-Null # Muting immediate pointless errors for brevity.
if ($keys -notmatch "The agent has no identities." -or [string]::IsNullOrEmpty($keys))
{
  # Do Nothing.
  return
} else
{
  ssh-add "$HOME\.ssh\alan_powershell_ssh_key" 2>&1 | Out-Null # Muting immediate pointless errors for brevity.
  Write-Output "SSH key added to the agent."
}
