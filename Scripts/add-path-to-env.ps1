param (
  [string]$NewPath
)
if(-not $NewPath)
{
  Write-Host "No path specified."
  return
}
if (-not [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine).Contains($NewPath))
{
  [Environment]::SetEnvironmentVariable("Path", $env:Path + ";" + $NewPath, [EnvironmentVariableTarget]::Machine)
  Write-Output "Added $NewPath to PATH."
} else
{
  Write-Output "$NewPath is already in PATH."
}
