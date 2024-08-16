# This script is just a convience for starting WSL when it's for some reason, disabled.

# Getting the instance of the service so we can check it's properties.
$service = Get-CimInstance Win32_Service | Where-Object Name -eq "WSLService"

# If the service isn't found, it's name is gonna be an empty string.
if ($service.Name.Length -eq 0) {
  Write-Host "WSL2 is not installed."
  # If the startup type is disabled, we need to enable / set it to manual so it can be started using the 'wsl' command within the terminal.
  # NOTE: MUST USE gsudo / sudo TO GET PERMISSION.
} elseif ($service.StartMode -eq "Disabled") {
  sudo Set-Service WSLService -StartupType Manual
  Write-Host "WSL has been started."
  # If the service is already in the 'manual' mode, then no need to start it, just use the 'wsl' command within the terminal to start it.
} else {
  Write-Host "WSL Service is already running."
}
