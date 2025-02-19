# WARN: This script was an attempt to create a Lua project manager, but was redundant and included misenterpretations on how
# LuaRocks environments should be managed. It doesn't properly handle environment activation and may conflict with existing LuaRocks
# configurations. Use with caution and consider using official LuaRocks commands instead.
param (
    [Parameter(Mandatory=$false)]
    [string]$Command
    )
# Establishing Current Location Variables. (This is where we will install modules, in our current lua project's working tree)
$projectRoot = Get-Location
$luaModulesDir = Join-Path $projectRoot "lua_modules"
# Initializing The Current Directory As A Lua Project. (But first checking with the user.)
if (-not (Test-Path (Join-Path $projectRoot ".luarocks"))) {
  $answer = Read-Host -Prompt "This is not a lua project, do you want to create one? (y/n)"
    if ($answer -eq 'y') {
      Write-Host "Initializing LuaRocks project..."
        luarocks init
    } else {
      Write-Host "Cancelling, please initialize a project before using lunar manager."
        exit 
    }
}
#  IMPORTANT: THIS ACTUALLY ACTIVATING THE ENVIRONMENT.
# Set Appropriate Environment Variables For Current Local Project. (Constantly sets them just in case moving between lua projects.)
if ($env:LUA_PATH -like "$projectRoot") {
  Write-Host "Project environment already active."
} else {
  Write-Host "Activating / Switching Lunarocks environment."
}
$env:LUA_PATH = "$luaModulesDir\share\lua\5.4\?.lua;$luaModulesDir\share\lua\5.4\?\init.lua"
$env:LUA_CPATH = "$luaModulesDir\lib\lua\5.4\?.dll"
$env:PATH = "$luaModulesDir\bin;" + $env:PATH
# Finally, If A Command Is Provided, Execute It.
if ($Command) {
Write-Host $Command
  if ($Command -eq "install") {
Write-Host "yay"
    $packageName = $args[0]
      Write-Host "Installing package: $packageName"
      luarocks install --tree="$luaModulesDir" $packageName
  }
  else {
    Write-Host "Executing LuaRocks command: $Command $args"
      luarocks $Command $args
  }
}
