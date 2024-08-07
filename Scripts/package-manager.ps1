param (
  [string]$command,
  [string]$packageName
)

function Install-ChocoIfMissing {
  if (-not (Get-Command choco -ErrorAction SilentlyContinue)){
    Write-Host -ForegroundColor Magneta "Installing Chocolatey"
    # Temporarily allowing execution of remote scripts.
    Set-ExecutionPolicy Bypass -Scope Process -Force 
    # Temporarily Downloading and executing the install script for the choco package manager.
    Invoke-Expression ((New-Object System.Net.WebClientx).DownloadString('https://community.chocolatey.org/install.ps1'))
    # Notifying User:
    Write-Host -ForegroundColor Green "Chocolatey now installed, please run your previous command again."
  } else {
    return $true # It's installed.
  }
}

#function Get-WingetPackages { NOTE: WORK IN PROGRESS
#  winget list --accept-source-agreements | ForEach-Object {
#    # Removing trailing and leading whitespace
#    $line = $_.Trim()
#    # Split the line into an array of strings, based on a sequence of two or more whitespace characters.
#    $parts = $line -split '\s{2,}'
#    if ($parts.Length -ge 2) {
#      [PSCustomObject]@{
#        Name    = $parts[0]
#        Version = $parts[1]
#        Source  = "Winget"
#      }
#    }
#  }
#}

#function Get-ChocoPackages { NOTE: WORK IN PROGRESS
#  return choco list --limit-output | ForEach-Object {
#    $parts = $_ -split '\|'
#    [PSCustomObject]@{
#      Name = $parts[0]
#      Version = $parts[1]
#      Source = "Chocolatey"
#    }
#  }
#}

if (Install-ChocoIfMissing) {
  switch ($command) {
    "list" {
      Write-Host "PowerShell Modules:"
      Get-Module -ListAvailable | Select-Object Name, Version | Format-Table -AutoSize

      Write-Host "`nWinget Packages:"
      winget list

      Write-Host "`nChocolatey Packages:"
      choco list
    }

    "installed" {
      $psModules = Get-Module -ListAvailable | Select-Object Name, Version, @{Name="Source"; Expression={"PowerShell"}}
      $wingetPackages = Get-WingetPackages
      $chocoPackages = Get-ChocoPackages

      $allPackages = $psModules  + $wingetPackages + $chocoPackages
      $allPackages | Format-Table -AutoSize

      Write-Host -ForegroundColor Green "Total Packages: $($allPackages.Count)"
      Write-Host "PowerShell Modules: $($psModules.Count)"
      Write-Host "Winget Packages: $($wingetPackages.Count)"
      Write-Host "Chocolatey Packages: $($chocoPackages.Count)"
    }

    "sources" {
      Write-Host "PowerShell Package Sources:"
      Get-PackageSource | Format-Table -AutoSize

      Write-Host "`nWinget Sources:"
      winget source list

      Write-Host "`nChocolatey Sources:"
      choco source list
    }

    "install" {
      if (-not($packageName -match "^winget") -or -not($packageName -match "^choco")){
        Install-Module -Name $packageName -Scope CurrentUser -Force
      } elseif ($packageName -match "^winget:") {
        $package = $packageName -replace "^winget:", ""
        winget install $package --accept-package-agreements --accept-source-agreements
      } elseif ($packageName -match "^choco:") {
        $package = $packageName -replace "^choco:", ""
        sudo choco install $package -y
      }
    }

    "update" {
      if ($packageName) {
        if (-not($packageName -match "^winget") -or -not($packageName -match "^choco")){
          Update-Module -Name $packageName -Force
        } elseif ($packageName -match "^winget:") {
          $package = $packageName -replace "^winget:", ""
          winget upgrade $package
        } elseif ($packageName -match "^choco:") {
          $package = $packageName -replace "^choco:", ""
          sudo choco upgrade $package -y
        }
      }
      else {
        Write-Host "Updating PowerShell..."
        winget install --id Microsoft.Powershell --source winget

        Write-Host "`nUpdating PowerShell Modules..."
        Get-InstalledModule | Update-Module -Force

        Write-Host "`nUpdating Winget Packages..."
        winget upgrade --all --source winget -h --accept-package-agreements --accept-source-agreements --include-unknown

        Write-Host "`nUpdating Chocolatey Packages..."
        sudo choco upgrade all -y
      }
    }

    "uninstall" {
      if (-not($packageName -match "^winget") -or -not($packageName -match "^choco")){
        Uninstall-Module -Name $packageName -Force
      } elseif ($packageName -match "^winget:") {
        $package = $packageName -replace "^winget:", ""
        winget uninstall $package
      } elseif ($packageName -match "^choco:") {
        $package = $packageName -replace "^choco:", ""
        sudo choco uninstall $package -y
      }
    }

    "find" {
      if (-not($packageName -match "^winget") -or -not($packageName -match "^choco")){
        Find-Module -Name $packageName
      } elseif ($packageName -match "^winget:") {
        $package = $packageName -replace "^winget:", ""
        winget search $package
      } elseif ($packageName -match "^choco:") {
        $package = $packageName -replace "^choco:", ""
        choco search $package
      }
    }

    default {
      Write-Host @"
        Unknown action: $command
        Use one of the following:
        - list
        - install
        - update
        - uninstall
        - find
        - installed
        - sources
        Note: 
        - Prepend 'choco:' to use Chocolatey (e.g., pskg install choco:package-name)
        - Prepend 'winget:' to use Winget (e.g., pskg install winget:package-name)
        - Use no prefix for PowerShell modules
"@
    }
  }
}
