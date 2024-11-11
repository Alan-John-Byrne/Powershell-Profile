# NOTE: function reload { . $PROFILE }, FUNCTION NOT POSSIBLE, MUST USE '. $PROFILE'

# WARN: EXTRA SETTINGS
# IMPORTANT: Below is how to configure oh-my-posh theme (MUST HAVE INSTALLED oh-my-posh VIA CHOCOLATEY)
# TODO: Initialsing prompt theme using 'oh-my-posh'. (Disable / Enable - But comment out Prompt Alias prior to doing so)
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\gruvbox.omp.json" | Invoke-Expression
# IMPORTANT: TURNING AUTO-COMPLETE OFF BY DEFAULT:
Set-PSReadLineOption -PredictionSource None

# IMPORTANT: Setting up aliases, with corresponding functional name descriptors.
# Aliases Used: (You can pass arguments as normal to these aliases, as if you were passing to functions or scripts.)
$AliasDefinitions = [ordered]@{ # Keeping the ordered as specified.
  "sudo" =              "gsudo" # NOTE: Elevating permissions using gsudo (sudo) [Requires 'gsudo' package]
  # Regular Function Aliases:
  "edit" =              "Edit-PowerShell-Profile"
  "aliases" =           "Show-Profile-Aliases"
  "coding" =            "Go-To-Coding-Workspace"
  "csdev" =             "Go-To-C#-Development-Workspace"
  "pydev" =             "Go-To-Python-Development-Workspace"
  "ldev" =              "Go-To-Lua-Development-Workspace"
  "jsdev" =             "Go-To-JavaScript-Development-Workspace"
  "javadev" =           "Go-To-Java-Development-Workspace"
  "cppdev" =            "Go-To-C++-Development-Workspace"
  "tsdev" =             "Go-To-Typescript-Development-Workspace"
  "godev" =             "Go-To-Golang-Development-Workspace"
  "runjava" =           "Gradle-Run-Java"
  "buildcpp" =          "Build-CPP-Program"
  "runcpp" =            "Run-Cpp"
  "nvim-config" =       "Edit-Nvim-Config"
  "nvim-config-lazy" =  "Edit-LazyVim-Base-Config" # Not ever necessary really!
  "nvim-path" =         "Go-To-Nvim-Repo-Path"
  "nvim-plugins" =      "Go-To-Nvim-Plugins-Path"
  "profile" =           "Go-To-PowerShell-Profile"
  "ps-v" =              "Get-PowerShell-Version"
  "open" =              "Open-Current-Directory"
  "sshome" =            "Go-To-SSH-Install-Location"
  "get-username" =      "Get-Current-User-Username"
  "test-git" =          "Check-GitHub-SSH-Connection"
  "gdg" =               "Go-To-Godot-Games"
  "scripts" =           "Go-To-PowerShell-Scripts"
  "desktop" =           "Go-To-Desktop"
  "prof-dir" =          "Get-Powershell-Profile-Location"
  "env-vars" =          "Get-Environment-Variables"
  "appdata" =           "Go-To-Appdata"
  "start-wsl" =         "Start-WSL-Service"
  # Script Based Function Aliases:
  "autocomplete" =      "Toggle-AutoComplete"
  "get-prof" =          "Get-Profile"
  "pskg" =              "PowerShell-Package-Manager"
  "set-local-cred" =    "Set-GitLocalCredentials"
  "cred" =              "Get-GitLocalCredentials"
  "touch" =             "Create-File" 
  "scripts-out" =       "Show-PowerShell-Script-Names"
  "env-add-path" =      "Add-Path-To-Env-Variables"
  "generate-cert-pfx" = "Create-Certificate"
  "sign-executable" =   "Sign-Exectuable-With-Certificate"
}

# IMPORTANT: Setting up corresponding functions which pair with the aliases above.
# Defining Scripts Directory.
$ScriptsDir = "$HOME\Documents\Powershell\scripts"
# Corresponding Functions Used:
$FunctionDefinitions = [ordered]@{ # Keeping the ordered as specified.
  # Regular Function Aliases:
  "Edit-PowerShell-Profile" =                 { profile; nvim $(get-prof) }
  "Show-Profile-Aliases" =                    { Write-Host "`nPowershell Profile Aliases:`n$($AliasDefinitions.GetEnumerator() | Format-Table -Property Name, Value -AutoSize | Out-String)" }
  "Go-To-Coding-Workspace" =                  { Set-Location "$HOME\Documents\PowerShell\coding" }
  "Go-To-C#-Development-Workspace" =          { Set-Location "$HOME\Documents\PowerShell\coding\csdev" }
  "Go-To-Python-Development-Workspace" =      { Set-Location "$HOME\Documents\PowerShell\coding\pydev" }
  "Go-To-Lua-Development-Workspace" =         { Set-Location "$HOME\Documents\PowerShell\coding\ldev" }
  "Go-To-JavaScript-Development-Workspace" =  { Set-Location "$HOME\Documents\PowerShell\coding\jsdev" }
  "Go-To-Java-Development-Workspace" =        { Set-Location "$HOME\Documents\PowerShell\coding\javadev" }
  "Go-To-C++-Development-Workspace" =         { Set-Location "$HOME\Documents\PowerShell\coding\cppdev" }
  "Go-To-Typescript-Development-Workspace" =  { Set-Location "$HOME\Documents\PowerShell\coding\tsdev" }
  "Go-To-Golang-Development-Workspace" =      { Set-Location "$HOME\Documents\PowerShell\coding\godev" }
  "Go-To-PowerShell-Profile" =                { Set-Location "$HOME\Documents\Powershell" }
  "Go-To-Godot-Games" =                       { Set-Location "$HOME\Desktop\Games\Godot Games" }
  "Go-To-PowerShell-Scripts" =                { Set-Location "$HOME\Documents\PowerShell\scripts" }
  "Go-To-Desktop" =                           { Set-Location "$HOME\Desktop\" }
  "Go-To-Nvim-Repo-Path" =                    { Set-Location "$HOME\AppData\Local\nvim" } 
  "Go-To-Nvim-Plugins-Path" =                 { Set-Location "$HOME\AppData\Local\nvim\lua\custom\plugins" }
  "Go-To-Appdata" =                           { Set-Location "$HOME\AppData\"}
  "Go-To-SSH-Install-Location" =              { Set-Location "$HOME\.ssh" }
  "Edit-Nvim-Config" =                        { Set-Location "$HOME\AppData\Local\nvim" ; nvim 'init.lua' ; profile }
  "Edit-LazyVim-Base-Config" =                { Set-Location "$HOME\AppData\Local\nvim-data\lazy\LazyVim\lua\lazyvim"; nvim 'init.lua'; profile}
  "Get-Powershell-Profile-Location" =         { return "$HOME\Documents\Powershell" }
  "Get-PowerShell-Version" =                  { Write-Host "Current PowerShell Version: $($PSVersionTable.PSVersion)" -ForegroundColor Black -BackgroundColor Green }
  "Get-Current-User-Username" =               { return (whoami | ForEach-Object { $_.Split('\') })[-1] }
  "Get-Environment-Variables" =               { Get-ChildItem env:* | sort-object name}
  "Open-Current-Directory" =                  { Invoke-Item . }
  "Check-GitHub-SSH-Connection" =             { ssh -T git@github.com }
  "Gradle-Run-Java" =                         { .\gradlew run }
  "Build-CPP-Program" =                       { cmake -S . -B build ; cmake --build build}
  "Run-Cpp" =                                 { ./bin/*.exe }
  # Script Based Function Aliases:
  "Get-Profile" =                             { & "$ScriptsDir\get-profile.ps1" }
  "Get-GitLocalCredentials" =                 { & "$ScriptsDir\git-get-cred.ps1" }
  "Set-GitLocalCredentials" =                 { param($localUsername, $localEmail); & "$ScriptsDir\git-set-cred.ps1" -localUsername $localUsername -localEmail $localEmail }
  "Sign-Exectuable-With-Certificate" =        { param($PfxFilePath, $Pass, $ExecutablePath); $Password = $(ConvertTo-SecureString $Pass -AsPlainText); & "$ScriptsDir\sign-executable.ps1" -PfxFilePath $PfxFilePath -Password $Password -ExecutablePath $ExecutablePath}
  "Show-PowerShell-Script-Names" =            { & "$ScriptsDir\list-scripts.ps1" -scriptsPath $ScriptsDir }
  "Start-WSL-Service" =                       { & "$ScriptsDir\start-wsl.ps1" }
  "Toggle-AutoComplete" =                     { & "$ScriptsDir\toggle-autocomplete.ps1" }
  "PowerShell-Package-Manager" =              { param($command, $packageName); & "$ScriptsDir\package-manager.ps1" -command $command -packageName $packageName }
  "Create-File" =                             { param($path_filename); & "$ScriptsDir\touch-create-file.ps1" -path_filename $path_filename }
  "Add-Path-To-Env-Variables" =               { param($NewPath); & "$ScriptsDir\add-path-to-env.ps1" -newPath $NewPath}
  "Create-Certificate" =                      { param($SubjectName, $Pass, $PfxFilePath); $Password = $(ConvertTo-SecureString $Pass -AsPlainText); & "$ScriptsDir\create-self-signed-cert-pfx-file.ps1" -SubjectName $SubjectName -Password $Password -PfxFilePath $PfxFilePath }

  # AUTO SCRIPTS (No Alias Required): 
  # Called Automatically:
  "Prompt" =                                  { & "$ScriptsDir\appearance.ps1" } # Changing Appearance.
  # Explicitly Called Scripts:
  "Start-SSHAgent" =                          { & "$ScriptsDir\start-ssh-agent.ps1" }
  "Share-Profile-With-VSCode-Extension" =     { Get-Content -Path "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" | Set-Content -Path "$HOME\Documents\PowerShell\profile.ps1" }
}

# IMPORTANT: ENVIRONMENT VARIABLES:
# NOTE: SETTING LOCAL ENVIRONMENT VARIABLES. (WILL DIFFER DEPENDING ON SOFTWARE USED BY YOUR MACHINE)
# Set INCLUDE path
$vcIncludePath = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.41.34120\include"
$ucrtIncludePath = "${env:ProgramFiles(x86)}\Windows Kits\10\Include\10.0.22621.0\ucrt"
$sdkIncludePath = "${env:ProgramFiles(x86)}\Windows Kits\10\Include\10.0.22621.0\shared"
$env:INCLUDE = "$vcIncludePath;$ucrtIncludePath;$sdkIncludePath"
# Set LIB path
$vcLibPath = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.41.34120\lib\x64"
$ucrtLibPath = "${env:ProgramFiles(x86)}\Windows Kits\10\Lib\10.0.22621.0\ucrt\x64"
$sdkLibPath = "${env:ProgramFiles(x86)}\Windows Kits\10\Lib\10.0.22621.0\um\x64"
$env:LIB = "$vcLibPath;$ucrtLibPath;$sdkLibPath"
# IMPORTANT: Java Setup: JAVA JDK INSTALLATION REQUIRED.
$env:JAVA_HOME = "${env:ProgramFiles}\Java\jdk-17" # NOTE: Standard (required) for Java, the 'JAVA_HOME' locates the JDK tools needed by programs. (SPECIFIC VERSION REQUIRED BY NVIM-JDTLS)
# IMPORTANT: C++ & C Setup: NINJA BUILD TOOLS INSTALLATION REQUIRED.
$env:CMAKE_GENERATOR = "Ninja" # NOTE: Specifying the default build system / tools used by CMake to compile and link projects from CMakeLists.txt files.
$env:CMAKE_EXPORT_COMPILE_COMMANDS = "ON" # IMPORTANT: We need to tell the Ninja generator to create instructions for the clangd lsp, on how projects are structured.
# User-specific paths
$userPaths = @(
  "C:\Windows\System32\OpenSSH\",
  "C:\mingw64\bin",# NOTE:  Essential for Tree-sitter in Neovim: provides GCC toolchain for compiling language grammars and native modules.
  "D:\Gradle\gradle-7.3.3\bin", # IMPORTANT: Build tools required for creating java projects.
  "D:\Microsoft VS Code\bin",
  "D:\PuTTY\",
  "$HOME\.cargo\bin",
  "$HOME\.dotnet\tools",
  "$HOME\AppData\Local\Android\Sdk\platform-tools",
  "$HOME\AppData\Local\Microsoft\WindowsApps",
  "$HOME\AppData\Roaming\npm",
  "$HOME\AppData\Local\Programs\Python\Python39\",# IMPORTANT: Python installation. (Version 3.19 required for nvim-jdtls)
  "$HOME\AppData\Local\Programs\Python\Python39\Scripts", # NOTE: Python Modules. (eg: pip)
  "${env:ProgramData}\chocolatey\bin",
  "${env:ProgramData}\chocolatey\lib\ninja\tools" # NOTE: Ninja build tools required by CMake for C++ projects in neovim.
  "${env:ProgramFiles(x86)}\oh-my-posh\bin",
  "${env:ProgramFiles(x86)}\NVIDIA Corporation\PhysX\Common",
  "${env:ProgramFiles}\Go\bin", # IMPORTANT: Golang installation.
  "${env:ProgramFiles}\Java\jdk-17\bin" # IMPORTANT: Must ensure java version is compatible with gradle build tools version.
  "${env:ProgramFiles}\WindowsPowerShell\Modules\Pester\5.5.0\bin",
  "${env:ProgramFiles}\CMake\bin",
  "${env:ProgramFiles}\Git\cmd",
  "${env:ProgramFiles}\nodejs",
  "${env:ProgramFiles}\Docker\Docker\resources\bin",
  "${env:ProgramFiles}\PowerShell\7\",
  "${env:ProgramFiles}\Microsoft SQL Server\150\Tools\Binn\",
  "${env:ProgramFiles}\dotnet\",
  "${env:ProgramFiles}\NVIDIA Corporation\NVIDIA NvDLISR",
  "${env:ProgramFiles}\gsudo\Current"
  "${env:ProgramFiles}\Lua", # IMPORTANT: Lua Setup. LUA INSTALLATION REQUIRED.
  "${env:ProgramFiles}\Apache\Maven\bin" # Build automation tool for Java projects (Binaries must be downloaded and added to specified directory).
)
$currentUserPaths = $env:Path -split ';'
$updatedUserPaths = ($currentUserPaths + $userPaths) | Select-Object -Unique
$env:Path = $updatedUserPaths -join ';'

# IMPORTANT: Sourcing extended aliases.
. $PSScriptRoot\temp_aliases.ps1
# Adding sourced temporary aliases:
$AliasDefinitions += $ExpandedAliases
# Adding sourced temporary function aliases:
$FunctionDefinitions += $ExpandedFunctionDefinitions
# Specifying and setting the corresponding aliases to the global functions set.
foreach ($alias in $AliasDefinitions.GetEnumerator())
{
  Set-Alias -Name $alias.Key -Value $alias.Value
}
# Initialising all function aliases as global functions. NOTE: Can be called from anywhere.
foreach ($functionName in $FunctionDefinitions.Keys)
{
  Set-Item -Path "function:\global:$functionName" -Value $FunctionDefinitions[$functionName]
}
# If starting from powershell, we copy over the profile.
# NOTE:  (Prevents duplicate terminals on startup in VSCODE)
$currentScriptName = Split-Path -Leaf $PSCommandPath
if ($currentScriptName.Contains('Microsoft'))
{
  Share-Profile-With-VSCode-Extension
}

# IMPORTANT: YOU MUST SET THE ENVIRONMENT VARIABLES FIRST BEFORE CALLING AUTO-SCRIPTS.
# NOTE: EXPLICIT AUTO SCRIPT CALLS:
Start-SSHAgent
# Going straight to the 'Powershell profile' folder on entering terminal.
if (!$env:VIRTUAL_ENV) # IMPORTANT: Only if we are not currently in a virtual python environment:
{
#  profile
}
