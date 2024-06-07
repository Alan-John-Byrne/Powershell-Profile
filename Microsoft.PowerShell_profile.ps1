# Aliases for editing and refreshing the PowerShell Profile:

# function reload { . $PROFILE }, FUNCTION NOT POSSIBLE, MUST USE '. $PROFILE'

# EDITING APPEARANCE ( MUST USE '. $PROFILE' for refresh ):
function Prompt {
    # Calling custom script.
    & "$HOME\Documents\PowerShell\scripts\appearance.ps1"
    # Remove 'PS>'
    return " "
}

# TURNING AUTO-COMPLETE OFF BY DEFAULT:
Set-PSReadLineOption -PredictionSource None

# SIMPLE FUNCTION ALIAS COMMANDS:
function Edit-PowerShell-Profile { code $(get-prof) }
# Alias: edit
function Go-To-PowerShell-Profile { Set-Location "$HOME\Documents\Powershell" }
# Alias: profile
function Get-PowerShell-Version { Write-Host "Current PowerShell Version: $($PSVersionTable.PSVersion)" -ForegroundColor Black -BackgroundColor Green }
# Alias: ps-v
function Open-Current-Directory { Invoke-Item . }
# Alias: open
function SSH-Location { Set-Location "$HOME\.ssh" }
# Alias: sshome
function Tail([string]$FileName, [int]$Lines = 10) { Get-Content -Path $FileName | Select-Object -Last $Lines }
# Alias: bot -filename -numberlines
function Head([string]$FileName, [int]$Lines = 10) { Get-Content -Path $FileName | Select-Object -First $Lines }
# Alias: top -filename -numberlines
function Get-Current-User-Username { return (whoami | ForEach-Object { $_.Split('\') })[-1] }
# Alias: get-username
function Check-GitHub-SSH-Connection { ssh -T git@github.com }
# Alias: test-git
function Go-To-Godot-Games { Set-Location "$HOME\Desktop\Games\Godot Games" }
# Alias: godot-games
function Go-To-PowerShell-Scripts { Set-Location "$HOME\Documents\PowerShell\scripts" }
# Alias: scripts

# SCRIPT BASED FUNCTION ALIAS COMMANDS:

$ScriptsDir = "$HOME\Documents\Powershell\scripts" # Scripts Directory

function Toggle-AutoComplete {
    $ScriptPath = "$ScriptsDir\toggle-autocomplete.ps1"
    & $ScriptPath
}
# Alias: autocomplete

function Show-Profile-Aliases { 
    $ScriptPath = "$ScriptsDir\list-aliases.ps1"
    & $ScriptPath
}
# Alias: aliases

function Get-Profile {
    $ScriptPath = "$ScriptsDir\get-profile.ps1"
    & $ScriptPath
}
# Alias: get-prof

function PowerShell-Package-Manager([string]$command, [string]$packageName) {
    $ScriptPath = "$ScriptsDir\package-manager.ps1"
    & $ScriptPath -command $command -packageName $packageName
}
# Alias: pskg -command -packageName

# GIT-CONFIG (Local & Global):
function Set-GitLocalCredentials([string]$localUsername, [string]$localEmail) {
    $ScriptPath = "$ScriptsDir\git-set-cred.ps1"
    & $ScriptPath -localUsername $localUsername -localEmail $localEmail
}
# Alias: set-local-cred -localUsername -localEmail

function Get-GitLocalCredentials {
    $ScriptPath = "$ScriptsDir\git-get-cred.ps1"
    & $ScriptPath
}
# Alias: cred 

# Various Linux Commands for PowerShell:
function Create-File ([string]$path_filename) {
    $ScriptPath = "$ScriptsDir\touch-create-file.ps1"
    & $ScriptPath -path_filename $path_filename
}
# Alias: touch -path

function Show-PowerShell-Script-Names {
    $ScriptPath = "$ScriptsDir\list-scripts.ps1"
    & $ScriptPath -scriptsPath $ScriptsDir
}
# Alias: scripts-out

# AUTO SCRIPTS:
function Start-SSHAgent {
    $ScriptPath = "$ScriptsDir\start-ssh-agent.ps1"
    & $ScriptPath
}
Start-SSHAgent

function Share-Profile-With-VSCode-Extension { Get-Content -Path "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" | Set-Content -Path "$HOME\Documents\PowerShell\profile.ps1" }
Share-Profile-With-VSCode-Extension

#                  **ALL ALIASES** 
# Note: Elevating permissions using gsudo (sudo) [Requires 'gsudo' package]
Set-Alias sudo                      gsudo 
Set-Alias edit                      Edit-PowerShell-Profile
Set-Alias profile                   Go-To-PowerShell-Profile
Set-Alias aliases                   Show-Profile-Aliases
Set-Alias get-prof                  Get-Profile
Set-Alias ps-v                      Get-PowerShell-Version
Set-Alias open                      Open-Current-Directory
Set-Alias get-username              Get-Current-User-Username  
Set-Alias autocomplete              Toggle-AutoComplete
Set-Alias pskg                      PowerShell-Package-Manager
Set-Alias sshome                    SSH-Location
Set-Alias test-git                  Check-GitHub-SSH-Connection
Set-Alias touch                     Create-File
Set-Alias godot-games               Go-To-Godot-Games
Set-Alias scripts                   Go-To-PowerShell-Scripts 
Set-Alias scripts-out               Show-PowerShell-Script-Names
Set-Alias set-local-cred            Set-GitLocalCredentials
Set-Alias cred                      Get-GitLocalCredentials
Set-Alias top                       Head
Set-Alias bot                       Tail