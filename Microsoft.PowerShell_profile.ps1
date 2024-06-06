# Aliases for editing and refreshing the PowerShell Profile:

# RELOAD FUNCTION NOT POSSIBLE, MUST USE '. $PROFILE'
# function reload { . $PROFILE }

# COMMON COMMANDS:
Set-Alias sudo gsudo # Elevating permissions using gsudo (sudo) [Requires 'gsudo' package]
function Edit-PowerShell-Profile { code $current_profile }
# Set-Alias edit Edit-PowerShell-Profile
function Go-To-PowerShell-Profile { cd "$HOME\Documents\Powershell" }
# Set-Alias profile Go-To-PowerShell-Profile
function Show-Profile-Aliases { bot $current_profile 20 }
# Set-Alias aliases Show-Profile-Aliases
function Get-PowerShell-Version { Write-Host "Current PowerShell Version: $($PSVersionTable.PSVersion)" -ForegroundColor Black -BackgroundColor Green }
# Set-Alias ps-v Get-PowerShell-Version
function Open-Current-Directory { Invoke-Item . }
# Set-Alias open Open-Current-Directory
function Get-Current-User-Username { return (whoami | ForEach-Object { $_.Split('\') })[-1] }
Set-Alias get-username Get-Current-User-Username

# EDITING APPEARANCE ( MUST USE '. $PROFILE' for refresh ):
function Prompt {
    # Calling custom script.
    & "C:\Users\$(get-username)\Documents\PowerShell\scripts\appearance.ps1"
    # Remove 'PS>'
    return " "
}

# AUTO-COMPLETE TOGGLE (OFF BY DEFAULT):
Set-PSReadLineOption -PredictionSource None
function Toggle-AutoComplete {
    $currentOption = (Get-PSReadLineOption).PredictionSource
    if ($currentOption -eq 'None') {
        Set-PSReadLineOption -PredictionSource History
        Write-Host "Auto-complete enabled."
    }
    else {
        Set-PSReadLineOption -PredictionSource None
        Write-Host "Auto-complete disabled."
    }
}
# Set-Alias autocomplete Toggle-AutoComplete

# PACKAGE MANAGEMENT:
function PowerShell-Package-Manager {
    param (
        [string]$command,
        [string]$packageName
    )
    
    switch ($command) {
        "list" { Get-Module -ListAvailable | Select-Object Name, Version | Format-Table -AutoSize }
        "installed" { 
            $installedModules = Get-Module -ListAvailable | Select-Object Name, Version
            $installedChocoPackages = gsudo choco list --no-color | Select-String "([^ ]+)\s+(\d+\.\d+\.\d+[^\s]*)" | ForEach-Object {
                $match = $_.Matches[0].Groups
                [PSCustomObject]@{ Name = $match[1].Value; Version = $match[2].Value }
            }

            Write-Host "Installed PowerShell Modules:"
            $installedModules | Format-Table -AutoSize
            Write-Host -ForegroundColor Green -NoNewline "Total PowerShell Modules: "
            Write-Host ($installedModules.Count)

            Write-Host "`nInstalled Chocolatey Packages:"
            $installedChocoPackages | Format-Table -AutoSize
            Write-Host -ForegroundColor Green -NoNewline "Total Chocolatey Packages: "
            Write-Host ($installedChocoPackages.Count)
        }
        "sources" { Get-PackageSource }
        "install" { 
            if ($packageName -match "choco:") {
                $package = $packageName -replace "choco:", ""
                sudo choco install $package -y
            }
            else {
                Install-Module -Name $packageName -Scope CurrentUser # Install only for the current user.
            } 
        } 
        "update" { 
            if ($packageName -match "choco:") {
                $package = $packageName -replace "choco:", ""
                choco upgrade $package -y
            }
            else {
                Update-Module -Name $packageName 
            }
        }
        "uninstall" { 
            if ($packageName -match "choco:") {
                $package = $packageName -replace "choco:", ""
                choco uninstall $package -y
            }
            else {
                Uninstall-Module -Name $packageName 
            }
        }
        "find" { 
            if ($packageName -match "choco:") {
                $package = $packageName -replace "choco:", ""
                choco search $package
            }
            else {
                Find-Module -Name $packageName 
            }
        }
        default { Write-Host "Unknown action: $command. Use one of the following: `nlist, install, update, uninstall, find, installed, sources." }
    }
}
# Set-Alias pskg PowerShell-Package-Manager

function Install-Chocolatey {
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Host "Chocolatey is already installed."
    }
    else {
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
}
# Set-Alias choco-install Install-Chocolatey

# SSH AGENT (STARTS AUTOMATICALLY AT SESSION START):
function Start-SSHAgent {
    $service = Get-Service -Name ssh-agent -ErrorAction SilentlyContinue
    if ($null -eq $service) {
        Write-Output "SSH agent service not found. Make sure OpenSSH is installed."
        return
    }
    if ($service.Status -ne 'Running') {
        Start-Service ssh-agent
        Write-Output "Started SSH agent service."
    }
    # Check if the key is already added to the agent
    $keys = ssh-add -L
    if ($keys -notmatch "The agent has no identities.") {
        # Do Nothing.
        return
    }
    else {
        ssh-add "$HOME\.ssh\alan_powershell_ssh_key"
        Write-Output "SSH key added to the agent."
    }
}
Start-SSHAgent # STARTING SSH AGENT
function SSH-Location { Set-Location "$HOME\.ssh" }
# Set-Alias sshome SSH-Location

function Check-GitHub-SSH-Connection {
    ssh -T git@github.com
}
# Set-Alias test-git Check-GitHub-SSH-Connection


# GIT-CONFIG (Local & Global):
function Set-GitLocalCredentials {
    param (
        [string]$localUsername,
        [string]$localEmail
    )

    # Check if the current directory is a Git repository
    if (-not (Test-Path .git)) {
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
    # Officially set those credentials for this repository.
    git config --local user.name "$localUsername"
    git config --local user.email "$localEmail"
    Write-Host "Local Git credentials set for current repository: $localUsername <$localEmail>"
}
# Set-Alias set-local-cred Set-GitLocalCredentials

function Get-GitLocalCredentials {
    # Check if the current directory is a Git repository
    if (-not (Test-Path .git)) {
        Write-Host "The current path is not a Git repository."
        return
    }

    # Retrieve the local Git username and email
    $localUsername = git config --local user.name
    $localEmail = git config --local user.email

    if ($localUsername -eq $null -and $localEmail -eq $null) {
        Write-Host "No local Git credentials are set for this repository."
    }
    else {
        Write-Host "Local Git credentials for this repository:"
        Write-Host "Username: $localUsername"
        Write-Host "Email: $localEmail"
    }
}
# Set-Alias cred Get-GitLocalCredentials

# Various Linux Commands for PowerShell:
function Create-File ([string]$path) {
    # Make sure that there is a name given for the new file. (could use '-not' here instead)
    if ([string]::IsNullOrEmpty($path)) {
        Write-Host "Please provide a name for the file you are making."
        return
    }
    if (Test-Path $path) {
        # Update the timestamp if the file exists
        (Get-Item $path).LastWriteTime = Get-Date
    }
    else {
        # Create an empty file if it does not exist
        New-Item $path -ItemType File
    }
}
# Set-Alias touch Create-File

function Head {
    param (
        [string]$FileName,
        [int]$Lines = 10
    )
    Get-Content -Path $FileName | Select-Object -First $Lines
}
# Set-Alias head Head

function Tail {
    param (
        [string]$FileName,
        [int]$Lines = 10
    )
    Get-Content -Path $FileName | Select-Object -Last $Lines
}
# Set-Alias tail Tail

# Shortcut Commands:
function Go-To-Godot-Games { cd "C:\Users\$(get-username)\Desktop\Games\Godot Games" }
# Set-Alias godot-games Go-To-Godot-Games

function Go-To-PowerShell-Scripts {
    if (Test-Path "C:\Users\$(get-username)\Documents\PowerShell\Scripts") {
        cd "C:\Users\$(get-username)\Documents\PowerShell\Scripts"
    }
    else {
        Write-Host "Scripts Directory incorrect, ensure it exists."
    }
}
# Set-Alias scripts Go-To-PowerShell-Scripts

function Show-PowerShell-Script-Names {
    $scriptsPath = "C:\Users\$(get-username)\Documents\PowerShell\Scripts"
    $files = Get-ChildItem -Path $scriptsPath -File
    foreach ($file in $files) { Write-Host "-> $($file.FullName)" }
}
# Set-Alias scripts-out Show-PowerShell-Script-Names

# DEBUGGING FUNCTION: (USED FOR DEBUGGING)
function check {

}

#######################################################################################################
# CHECKING THE CURRENT HOST PROFILE (VSCODE EXTENSION SUPPORT):
if(($PROFILE | ForEach-Object { $_.Split('\') })[-1] -eq "Microsoft.VSCode_profile.ps1"){
    $current_profile = "C:\Users\$(get-username)\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
} else {
    $current_profile = $PROFILE
}
function Share-Profile-With-VSCode-Extension {Get-Content -Path "C:\Users\$(get-username)\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" | Set-Content -Path "C:\Users\$(get-username)\Documents\PowerShell\profile.ps1"}
# Set-Alias vscode-profile Share-Profile-With-VSCode-Extension
# ON START SYNC WITH VSCODE EXTENSION:
Set-Alias vscode-profile Share-Profile-With-VSCode-Extension
vscode-profile
#######################################################################################################





#                  **ALL ALIASES** 
# Note: '#' Just means that the command was previously configured.
Set-Alias edit                      Edit-PowerShell-Profile
Set-Alias profile                   Go-To-PowerShell-Profile
#et-Alias vscode-profile            Share-Profile-With-VSCode-Extension
Set-Alias aliases                   Show-Profile-Aliases
Set-Alias ps-v                      Get-PowerShell-Version
Set-Alias open                      Open-Current-Directory
#et-Alias get-username              Get-Current-User-Username 
Set-Alias autocomplete              Toggle-AutoComplete
Set-Alias pskg                      PowerShell-Package-Manager
Set-Alias choco-install             Install-Chocolatey
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