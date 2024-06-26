param (
		[string]$command,
		[string]$packageName
      )

	switch ($command) {
		"choco-install" {
			if (Get-Command choco -ErrorAction SilentlyContinue) {
				Write-Host "Chocolatey is already installed."
			}
			else {
				Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
			}	
		}
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
			if($packageName){
				if ($packageName -match "choco:") {
					$package = $packageName -replace "choco:", ""
						choco upgrade $package -y
				}
				else {
					Update-Module -Name $packageName 
				}
			}else {
				# If we need to update powershell itself using winget, don't provide parameters.
				winget upgrade --id Microsoft.Powershell
				# Following upgrading / updating powershell, update all winget packages (Okay for home use, not your work / office).
				winget upgrade --all -h --accept-package-agreements --accept-source-agreements --include-unknown
				# Finally updating all chocolately packages.
				sudo choco upgrade all -y
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
		default { Write-Host "Unknown action: $command`n`nUse one of the following:`n`n-list`n-install`n-update`n-uninstall`n-find`n-installed`n-sources.`n`nNote: Remember to prepend 'choco:' to the front of your package name `nin order to use chocolately related functions. eg: pskg install choco:*package-name*" }
	}
