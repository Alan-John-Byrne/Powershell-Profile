# Aliases for editing and refreshing the PowerShell Profile:
# function reload { . $PROFILE } NOT POSSIBLE MUST USE '. $PROFILE'
function edit { code $PROFILE }
function profile {
    cd "$HOME\Documents\Powershell"
}

# Note: Also possible to create an alias this way.
function Show-Profile-Aliases { cat $PROFILE }
Set-Alias aliases Show-Profile-Aliases

# Elevate permissions using sudo:
Set-Alias sudo gsudo

# Editing Appearance ( MUST USE '. $PROFILE' for refresh ):
function Prompt {
    # Calling custom script.
    & "C:\Users\alanj\Documents\PowerShell\Scripts\appearance.ps1"
    # Remove 'PS>'
    return " "
}

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
        Write-Output "Powershell Git SSH Key already added."
        return
    } else {
        ssh-add "$HOME\.ssh\alan_powershell_ssh_key"
        Write-Output "SSH key added to the agent."
    }
}

Start-SSHAgent

# Various Linux Commands for PowerShell:
function touch ([string]$path) {
    if (Test-Path $path) {
        # Update the timestamp if the file exists
        (Get-Item $path).LastWriteTime = Get-Date
    } else {
        # Create an empty file if it does not exist
        New-Item $path -ItemType File
    }
}

# Shortcut Commands:
function home {
    cd 
}

function godot-games {
    $username = (whoami | ForEach-Object { $_.Split('\') })[-1]
    cd "C:\Users\$username\Desktop\Games\Godot Games"
}

function scripts {
    $username = (whoami | ForEach-Object { $_.Split('\') })[-1]
    if(Test-Path "C:\Users\$username\Documents\PowerShell\Scripts"){
        cd "C:\Users\$username\Documents\PowerShell\Scripts"
    } else {
        Write-Host "Scripts Directory incorrect, ensure it exists."
    }
}

function scripts-out {
    $username = (whoami | ForEach-Object { $_.Split('\') })[-1]
    $scriptsPath = "C:\Users\$username\Documents\PowerShell\Scripts"
    $files = Get-ChildItem -Path $scriptsPath -File
    foreach ($file in $files){
        Write-Host "-> $($file.FullName)"
    }
}

# AUTO-COMPLETION COMMANDS:
function Toggle-AutoComplete {
    $currentOption = (Get-PSReadLineOption).PredictionSource
    if ($currentOption -eq 'None') {
        Set-PSReadLineOption -PredictionSource History
        Write-Host "Auto-complete enabled."
    } else {
        Set-PSReadLineOption -PredictionSource None
        Write-Host "Auto-complete disabled."
    }
}
Set-Alias autocomplete Toggle-AutoComplete

# DEBUGGING FUNCTION: (USED FOR ACTUALLY DEBUGGING IN POWERSHELL)
function check {

}