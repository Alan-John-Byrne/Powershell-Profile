$current_host = ($PROFILE | ForEach-Object { $_.Split('\') })[-1]
# Checking if the current host is VS Code.
if ($current_host -eq "Microsoft.VSCode_profile.ps1")
{
  # If so, change it to the users main PowerShell Profile.
  $current_profile = "C:\Users\$(get-username)\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
} else
{
  $current_profile = $PROFILE
}
return $current_profile
