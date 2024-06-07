params (
	[string]$scriptsPath
)

$files = Get-ChildItem -Path $scriptsPath -File
foreach ($file in $files) { Write-Host "-> $($file.FullName)" }
