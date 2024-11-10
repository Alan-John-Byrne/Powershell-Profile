# Initial Setup:

# IMPORTANT: First checking to see if there is a virtual environment for python activated.
$virtual_env = ""
if ($env:VIRTUAL_ENV)
{
  $virtual_env = "Python-Virtual-Env->($($env:VIRTUAL_ENV.Split("\")[-1]))" #  NOTE: Extracting out the name of the virtual environment.
}

# NOTE: MAIN APPEARANCE SCRIPT:
$currentDrive = $PWD.Drive.Name
$currentLocation = Get-Location
# Different Parts of the prompt (each 'Write-Host' is a different segment of the prompt.)
if ($currentDrive -eq 'C')
{

  # Steps needed prior for drive C:
  $indexOfChar = $PWD.Path.IndexOf("\", $PWD.Path.IndexOf("\") + 1)
  $userNameFromPath = $PWD.Path.Substring($indexOfChar + 1)
  $indexOfUsername = $currentLocation.Path.IndexOf($userNameFromPath)
  $currentPath = $currentLocation.Path.Substring($indexOfUsername)
  $username = (whoami | ForEach-Object { $_.Split('\') })[-1]
  # Check for if the username is in the current path, otherwise we are in root.
  if ($currentPath.Contains($username))
  {
    Write-Host "$currentDrive`:\\ $($virtual_env) " -ForegroundColor Green -NoNewline # IMPORTANT: If we are in a virtual environment, prepend that virtual environment name:
    Write-Host "@ User" -ForegroundColor Gray -NoNewline
    Write-Host " -> " -ForegroundColor Yellow -NoNewline
    Write-Host "$currentPath" -ForegroundColor Cyan -NoNewline # Username in path (Necessary)
  } else
  {
    $path = "$currentDrive`:\\ ~ root $($virtual_env)" + $PWD.Path.Insert(2, "\")
    Write-Host "$($path.Substring(0, 11)) " -ForegroundColor Green -NoNewline # Green
    Write-Host "$($path.Substring(12, 36))" -ForegroundColor Cyan -NoNewline # Cyan
  }
} else
{

  $indexOfChar = $currentLocation.Path.IndexOf("\")
  $currentPath = $currentLocation.Path.Substring($indexOfChar + 1)
  if ($currentPath)
  {
    Write-Host "$currentDrive`:\\ ~ root $($virtual_env)" -ForegroundColor Green -NoNewline # Green # IMPORTANT: If we are in a virtual environment, prepend that virtual environment name:
    Write-Host "\$currentPath" -ForegroundColor Cyan -NoNewline # Cyan
  } else
  {
    Write-Host "$currentDrive`:\\ ~ root $($virtual_env)" -ForegroundColor Green -NoNewline # Green
  }
}
# Nice little design:
Write-Host " >>" -ForegroundColor Blue -NoNewline # Blue
# Remove 'PS>'
return " "
