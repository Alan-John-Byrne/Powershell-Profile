# function reload { . $PROFILE }, FUNCTION NOT POSSIBLE, MUST USE '. $PROFILE'
# Note: Elevating permissions using gsudo (sudo) [Requires 'gsudo' package]
# TURNING AUTO-COMPLETE OFF BY DEFAULT:
Set-PSReadLineOption -PredictionSource None
# Scripts Directory
$ScriptsDir = "$HOME\Documents\Powershell\scripts"
# Aliases Used:
$AliasDefinitions = [ordered]@{ # Keeping the ordered as specified.
    "sudo" = "gsudo"
    # Regular Function Aliases:
    "edit" = "Edit-PowerShell-Profile"
    "profile" = "Go-To-PowerShell-Profile"
    "ps-v" = "Get-PowerShell-Version"
    "open" = "Open-Current-Directory"
    "sshome" = "SSH-Location"
    "bot" = "Tail"
    "top" = "Head"
    "get-username" = "Get-Current-User-Username"
    "test-git" = "Check-GitHub-SSH-Connection"
    "gdg" = "Go-To-Godot-Games"
    "scripts" = "Go-To-PowerShell-Scripts"
    # Script Based Function Aliases:
    "autocomplete" = "Toggle-AutoComplete"
    "aliases" = "Show-Profile-Aliases"
    "get-prof" = "Get-Profile"
    "pskg" = "PowerShell-Package-Manager"
    "set-local-cred" = "Set-GitLocalCredentials"
    "cred" = "Get-GitLocalCredentials"
    "touch" = "Create-File"
    "scripts-out" = "Show-PowerShell-Script-Names"
}
# Specifying and setting the corresponding aliases to the global functions set.
foreach ($alias in $AliasDefinitions.GetEnumerator()) {
    Set-Alias -Name $alias.Key -Value $alias.Value
}
# Corresponding Functions Used:
$FunctionDefinitions = [ordered]@{ # Keeping the ordered as specified.
    # Regular Function Aliases:
    "Show-Profile-Aliases" =                { Write-Host "`nPowershell Profile Aliases:`n$($AliasDefinitions.GetEnumerator() | Format-Table -Property Name, Value -AutoSize | Out-String)" }
    "Edit-PowerShell-Profile" =             { code $(get-prof) }
    "Go-To-PowerShell-Profile" =            { Set-Location "$HOME\Documents\Powershell" }
    "Get-PowerShell-Version" =              { Write-Host "Current PowerShell Version: $($PSVersionTable.PSVersion)" -ForegroundColor Black -BackgroundColor Green }
    "Open-Current-Directory" =              { Invoke-Item . }
    "SSH-Location" =                        { Set-Location "$HOME\.ssh" }
    "Tail" =                                { param($FileName, $Lines = 10); Get-Content -Path $FileName | Select-Object -Last $Lines }
    "Head" =                                { param($FileName, $Lines = 10); Get-Content -Path $FileName | Select-Object -First $Lines }
    "Get-Current-User-Username" =           { return (whoami | ForEach-Object { $_.Split('\') })[-1] }
    "Check-GitHub-SSH-Connection" =         { ssh -T git@github.com }
    "Go-To-Godot-Games" =                   { Set-Location "$HOME\Desktop\Games\Godot Games" }
    "Go-To-PowerShell-Scripts" =            { Set-Location "$HOME\Documents\PowerShell\scripts" }
    # Script Based Function Aliases:
    "Toggle-AutoComplete" =                 { & "$ScriptsDir\toggle-autocomplete.ps1" }
    "Get-Profile" =                         { & "$ScriptsDir\get-profile.ps1" }
    "PowerShell-Package-Manager" =          { param($command, $packageName); & "$ScriptsDir\package-manager.ps1" -command $command -packageName $packageName }
    "Set-GitLocalCredentials" =             { param($localUsername, $localEmail); & "$ScriptsDir\git-set-cred.ps1" -localUsername $localUsername -localEmail $localEmail }
    "Get-GitLocalCredentials" =             { & "$ScriptsDir\git-get-cred.ps1" }
    "Create-File" =                         { param($path_filename); & "$ScriptsDir\touch-create-file.ps1" -path_filename $path_filename }
    "Show-PowerShell-Script-Names" =        { & "$ScriptsDir\list-scripts.ps1" -scriptsPath $ScriptsDir }
    # Auto Scripts (No Alias Required):
    # Called Automatically:
    "Prompt" =                              { & "$ScriptsDir\appearance.ps1" } # Changing Appearance.
    # Explicitly Called:
    "Start-SSHAgent" =                      { & "$ScriptsDir\start-ssh-agent.ps1" }
    "Share-Profile-With-VSCode-Extension" = { Get-Content -Path "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" | Set-Content -Path "$HOME\Documents\PowerShell\profile.ps1" }
}
# Initialising all functions as global functions that can be called from anywhere.
foreach ($functionName in $FunctionDefinitions.Keys) {
    Set-Item -Path "function:\global:$functionName" -Value $FunctionDefinitions[$functionName]
}
# EXPLICIT AUTO SCRIPT CALLS:
Start-SSHAgent
Share-Profile-With-VSCode-Extension
