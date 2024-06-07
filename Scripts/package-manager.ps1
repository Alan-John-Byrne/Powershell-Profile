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
