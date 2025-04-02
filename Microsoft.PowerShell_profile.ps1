# NOTE: 'function reload { . $PROFILE }' FUNCTION NOT POSSIBLE, MUST USE '. $PROFILE'

# WARN: EXTRA SETTINGS
# IMPORTANT: Below is how to configure oh-my-posh theme (MUST HAVE INSTALLED oh-my-posh VIA CHOCOLATEY)
# TODO: Initialsing prompt theme using 'oh-my-posh'. (Disable / Enable - But comment out 'Prompt' alias prior to doing so)
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\gruvbox.omp.json" | Invoke-Expression
# IMPORTANT: TURNING AUTO-COMPLETE OFF BY DEFAULT:
Set-PSReadLineOption -PredictionSource None

# IMPORTANT: Setting up aliases, with corresponding functional name descriptors.
# Aliases Used: (You can pass arguments as normal to these aliases, as if you were passing to functions or scripts.)
$AliasDefinitions = [ordered]@{ # Keeping the ordered as specified.
  "sudo" =              "gsudo" # NOTE: Elevating permissions using gsudo (sudo) [Requires 'gsudo' package]
  # Regular Function Aliases:
  "edit" =              "Edit-PowerShell-Profile"
  "open" =              "Open-Current-Directory"
  "aliases" =           "Show-Profile-Aliases"
  "coding" =            "Go-To-Coding-Workspace"
  "projects" =          "Go-To-Projects"
  "csdev" =             "Go-To-C#-Development-Workspace"
  "pydev" =             "Go-To-Python-Development-Workspace"
  "ldev" =              "Go-To-Lua-Development-Workspace"
  "jsdev" =             "Go-To-JavaScript-Development-Workspace"
  "javadev" =           "Go-To-Java-Development-Workspace"
  "cppdev" =            "Go-To-C++-Development-Workspace"
  "tsdev" =             "Go-To-Typescript-Development-Workspace"
  "godev" =             "Go-To-Golang-Development-Workspace"
  "nvim-path" =         "Go-To-Nvim-Repo-Path"
  "nvim-plugins" =      "Go-To-Nvim-Plugins-Path"
  "profile" =           "Go-To-PowerShell-Profile"
  "gdg" =               "Go-To-Godot-Games"
  "scripts" =           "Go-To-PowerShell-Scripts"
  "desktop" =           "Go-To-Desktop"
  "sshome" =            "Go-To-SSH-Install-Location"
  "appdata" =           "Go-To-Appdata"
  "nvim-config" =       "Edit-Nvim-Config"
  "ps-v" =              "Get-PowerShell-Version"
  "env-vars" =          "Get-Environment-Variables"
  "prof-dir" =          "Get-Powershell-Profile-Location"
  "get-username" =      "Get-Current-User-Username"
  "createjava" =        "Create-Java-Gradle-Project"
  "runjava" =           "Gradle-Run-Java"
  "buildcpp" =          "Build-CPP-Program"
  "runcpp" =            "Run-Cpp"
  "start-wsl" =         "Start-WSL-Service"
  "test-git" =          "Check-GitHub-SSH-Connection"
  "which" =             "Where-is-path"
  # Script Based Function Aliases:
  "get-prof" =          "Get-Profile"
  "get-local-cred" =    "Get-GitLocalCredentials"
  "set-local-cred" =    "Set-GitLocalCredentials"
  "scripts-out" =       "Show-PowerShell-Script-Names"
  "autocomplete" =      "Toggle-AutoComplete"
  "pskg" =              "PowerShell-Package-Manager"
  "touch" =             "Create-File" 
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
  "Go-To-Coding-Workspace" =                  { Set-Location "D:\4-Personal-OneDrive\OneDrive\Coding" }
  "Go-To-Projects" =                          { Set-Location "D:\9-Projects"}
  "Go-To-C#-Development-Workspace" =          { Set-Location "D:\4-Personal-OneDrive\OneDrive\Coding\csdev" }
  "Go-To-Python-Development-Workspace" =      { Set-Location "D:\4-Personal-OneDrive\OneDrive\Coding\pydev" }
  "Go-To-Lua-Development-Workspace" =         { Set-Location "D:\4-Personal-OneDrive\OneDrive\Coding\ldev" }
  "Go-To-JavaScript-Development-Workspace" =  { Set-Location "D:\4-Personal-OneDrive\OneDrive\Coding\jsdev" }
  "Go-To-Java-Development-Workspace" =        { Set-Location "D:\4-Personal-OneDrive\OneDrive\Coding\javadev" }
  "Go-To-C++-Development-Workspace" =         { Set-Location "D:\4-Personal-OneDrive\OneDrive\Coding\cppdev" }
  "Go-To-Typescript-Development-Workspace" =  { Set-Location "D:\4-Personal-OneDrive\OneDrive\Coding\tsdev" }
  "Go-To-Golang-Development-Workspace" =      { Set-Location "D:\4-Personal-OneDrive\OneDrive\Coding\godev" }
  "Go-To-PowerShell-Profile" =                { Set-Location "$HOME\Documents\Powershell" }
  "Go-To-Godot-Games" =                       { Set-Location "$HOME\Desktop\Games\Godot Games" }
  "Go-To-PowerShell-Scripts" =                { Set-Location "$HOME\Documents\PowerShell\scripts" }
  "Go-To-Desktop" =                           { Set-Location "$HOME\Desktop\" }
  "Go-To-Nvim-Repo-Path" =                    { Set-Location "$HOME\AppData\Local\nvim" } 
  "Go-To-Nvim-Plugins-Path" =                 { Set-Location "$HOME\AppData\Local\nvim\lua\custom\plugins" }
  "Go-To-Appdata" =                           { Set-Location "$HOME\AppData\"}
  "Go-To-SSH-Install-Location" =              { Set-Location "$HOME\.ssh" }
  "Edit-Nvim-Config" =                        { Set-Location "$HOME\AppData\Local\nvim" ; nvim 'init.lua' ; profile }
  "Get-Powershell-Profile-Location" =         { return "$HOME\Documents\Powershell" }
  "Get-Current-User-Username" =               { return (whoami | ForEach-Object { $_.Split('\') })[-1] }
  "Get-PowerShell-Version" =                  { Write-Host "Current PowerShell Version: $($PSVersionTable.PSVersion)" -ForegroundColor Black -BackgroundColor Green }
  "Get-Environment-Variables" =               { Get-ChildItem env:* | sort-object name}
  "Open-Current-Directory" =                  { Invoke-Item . }
  "Create-Java-Gradle-Project" =              { gradle init --type java-application }
  "Gradle-Run-Java" =                         { .\gradlew run --console=plain} # NOTE: Setting console to plain, so we don't get annoying gradle loading symbols in standard output.
  "Build-CPP-Program" =                       { cmake -G "Ninja" -S . -B build ; cmake --build build --verbose} # IMPORTANT: Specifying the generator with the '-G' parameter rather than setting it globally. (Prevents classhes.)
  "Run-Cpp" =                                 { ./bin/*.exe }
  "Check-GitHub-SSH-Connection" =             { ssh -T git@github.com }
  "Where-is-path" =                           { param($object) where.exe $object } # NOTE: Undoing PowerShell's 'where' command problem.
  # Script Based Function Aliases:
  "Get-Profile" =                             { & "$ScriptsDir\get-profile.ps1" }
  "Get-GitLocalCredentials" =                 { & "$ScriptsDir\git-get-cred.ps1" }
  "Set-GitLocalCredentials" =                 { param($localUsername, $localEmail); & "$ScriptsDir\git-set-cred.ps1" -localUsername $localUsername -localEmail $localEmail }
  "Show-PowerShell-Script-Names" =            { & "$ScriptsDir\list-scripts.ps1" -scriptsPath $ScriptsDir }
  "Start-WSL-Service" =                       { & "$ScriptsDir\start-wsl.ps1" }
  "Toggle-AutoComplete" =                     { & "$ScriptsDir\toggle-autocomplete.ps1" }
  "Sign-Exectuable-With-Certificate" =        { param($PfxFilePath, $Pass, $ExecutablePath); $Password = $(ConvertTo-SecureString $Pass -AsPlainText); & "$ScriptsDir\sign-executable.ps1" -PfxFilePath $PfxFilePath -Password $Password -ExecutablePath $ExecutablePath}
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

# WARN: SPECIFIC LOCAL ENVIRONMENT VARIABLES (*will differ depending on the software used on your machine*):
# IMPORTANT: C++ & C Setup: (NINJA BUILD TOOLS INSTALLATION REQUIRED)
#$env:CMAKE_GENERATOR = "Ninja" # WARN: Specifying the default build system / generator used by CMake to compile and link projects, from CMakeLists.txt files, globally. (GLOBALLY COULD CAUSE PROBLEMS / CLASHES, INSTEAD USE THE -G ['Generator'] PARAMETER IN THE CMAKE TOOLSET)
$env:CMAKE_EXPORT_COMPILE_COMMANDS = "ON" # IMPORTANT: We need to tell the Ninja generator to create instructions for the 'clangd' LSP. It details how C++ projects are structured.
$env:CMAKE_BUILD_TYPE = "Debug" # NOTE: We need to generate debug symbols for debugging using nvim-dap. (*FINE TO SET GLOBALLY AS DEBUGGING IS STANDARD*)
# IMPORTANT: Java Setup: (JAVA JDK INSTALLATION REQUIRED + Gradle Build Tools Compatibility Required) 
$env:JAVA_HOME = "${env:ProgramFiles}\Java\jdk-21" # NOTE: Java 21 *REQUIRED* as 'JAVA_HOME' for nvim-jdtls to function. Variable points to the JDK itself, providing programs the java tools required to function.
# IMPORTANT: C# Setup: (DOTNET SDK INSTALLATION REQUIRED - .NET6.0 SDK / RUNTIME REQUIRED FOR OMNISHARP SUPPORT IN NEOVIM - LATEST FOR BUILDING PROJECTS IS .NET8.*.*)
$env:DOTNET_ROOT = "${env:ProgramFiles}\dotnet\"
# IMPORTANT: WEZTERM CONFIGURATION: (Putting it in my NeoVim Configuration Directory)
# $env:WEZTERM_CONFIG_FILE = "$HOME\AppData\Local\nvim\lua\config\.wezterm.lua" CANNOT BE DONE WITHIN PROFILE, MUST BE GLOBAL VIA SYSTEM GUI.
# NOTE: User-specific / generic environment paths.
# REMEMBER: PowerShell inherits the global environment variables.
# *BUT*, if you’ve customized your $PROFILE, it will override / modify
# the global PATH for PowerShell sessions. 
$userPaths = @(
  "C:\Windows\System32",
  "C:\Windows\System32\OpenSSH",
  "D:\Microsoft VS Code\bin",
  "D:\PuTTY\",
  "C:\Program Files\WezTerm",
  "C:\Users\alanj\AppData\Roaming\npm\node_modules", # NOTE: Required for accessing global node modules.
  "$HOME\AppData\Local\Android\Sdk\platform-tools",
  "$HOME\AppData\Local\Microsoft\WindowsApps",
  "${env:ProgramData}\chocolatey\bin", # NOTE: *Almost* any package installed via the chocolatey package manager, it's binary is automatically accessible via this entry.
  "${env:ProgramFiles(x86)}\NVIDIA Corporation\PhysX\Common",
  "${env:ProgramFiles}\WindowsPowerShell\Modules\Pester\5.5.0\bin",
  "${env:ProgramFiles}\Git\cmd",
  "${env:ProgramFiles}\Docker\Docker\resources\bin",
  "${env:ProgramFiles}\Microsoft SQL Server\150\Tools\Binn",
  "${env:ProgramFiles}\NVIDIA Corporation\NVIDIA app\NvDLISR",
  "${env:ProgramFiles}\gsudo\Current"
  # TODO: NEOVIM DEPENDENCIES:
  "C:\tools\neovim\nvim-win64\bin", # NOTE: Making 'nvim.exe' accessible.
  "C:\Users\alanj\AppData\Local\nvim-data\mason\bin", # IMPORTANT: *Required* for Mason Plugin Manager plugins to be 'findable' by other setup plugins via $PATH.
  "${env:ProgramFiles(x86)}\oh-my-posh\bin", # REMEMBER: Makes shit look nice.
  # XXX: Executables Required for language support:
  "${env:ProgramFiles}\nodejs",# WARN: Binary executable required for JavaScript support
  "$HOME\AppData\Roaming\npm", # WARN: Node.js package manager required for building *some* plugins.
  "${env:ProgramFiles}\dotnet",# WARN: Binary executable required for C# support
  "C:\omnisharp\OmniSharp.exe", # WARN: Another binary executable required for c# support
  "${env:ProgramFiles}\LLVM\bin", # WARN: C++ Debugger Setup. (lldb.exe) / lldb command.
  "${env:ProgramFiles}\CMake\bin", # WARN: Build System Generator required for creating C++ projects.
  "${env:ProgramData}\chocolatey\lib\ninja\tools" # WARN: Ninja build tools required by CMake for C++ projects. (For when using the 'clangd' LSP)
  "${env:ProgramFiles}\Lua\5.1", # NOTE: Lua Setup Verson 5.1 (lua.exe) / lua command. Required for many of neovim's plugins (e.g.:'image.nvim') build processes. (MOST COMPATIBLE WITH NEOVIM) 
  "${env:ProgramFiles}\Go\bin", # WARN: Golang & Go 'Delve' Debug Adapter Setup. (go.exe + dlv.exe) / go command.
  "${env:JAVA_HOME}\bin", # WARN: Java JDK (*Gradle Build Tools Compatibility Required*)
  "D:\Gradle\gradle-8.5\bin", # WARN: Gradle Build Tools required for creating java projects. (*Java JDK Compatibility Required*)
  # XXX: Python dependencies for *some* of the above executables:
  "$HOME\AppData\Local\Programs\Python\Launcher" # WARN: Python setup. ('py.exe' & 'pyw.exe') / py & pyw command. (Uses the latest version of python installed on your system.)
  "$HOME\AppData\Local\Programs\Python\Python313\Scripts", # NOTE: My Latest version of Pythons (3.13) Modules. (eg: pip)
  "$HOME\AppData\Local\Programs\Python\Python310",# IMPORTANT: Python Version 3.10 *REQUIRED* for LLVM. (lldb needs the 'python310.dll' for C++ project debugging using nvim-dap)
  "$HOME\AppData\Local\Programs\Python\Python310\Scripts", # NOTE: Python 3.10 Modules. (eg: pip)
  "$HOME\AppData\Local\Programs\Python\Python39\",# IMPORTANT: Python Version 3.9 *REQUIRED* for nvim-jdtls.
  "$HOME\AppData\Local\Programs\Python\Python39\Scripts", # NOTE: Python 3.9 Modules. (eg: pip)
  # XXX : 'treesitter.nvim' requirements in Neovim:
  "C:\mingw64\bin", # WARN: Providing the GCC toolchain for compiling language grammars and native modules.
  "$HOME\.cargo\bin"# WARN: Providing the Rust toolchain for compiling language grammars and native modules.
)
# IMPORTANT: Setting User-specific environment paths.
$currentUserPaths = $env:Path -split ';'
$updatedUserPaths = ($currentUserPaths + $userPaths) | Select-Object -Unique
$env:Path = $updatedUserPaths -join ';'

# WARN: Sourcing extended aliases.
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
# Initialising all function aliases as global functions.  NOTE: Can be called from anywhere.
foreach ($functionName in $FunctionDefinitions.Keys)
{
  Set-Item -Path "function:\global:$functionName" -Value $FunctionDefinitions[$functionName]
}
# If starting from powershell, we copy over the profile.
# NOTE: (Prevents duplicate terminals on startup in VSCODE)
$currentScriptName = Split-Path -Leaf $PSCommandPath
if ($currentScriptName.Contains('Microsoft'))
{
  Share-Profile-With-VSCode-Extension
}

# NOTE: EXPLICIT AUTO SCRIPT CALLS: (YOU MUST SET THE ENVIRONMENT VARIABLES FIRST BEFORE CALLING AUTO-SCRIPTS)
Start-SSHAgent
