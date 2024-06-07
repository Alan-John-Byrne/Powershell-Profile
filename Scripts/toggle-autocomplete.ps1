$currentOption = (Get-PSReadLineOption).PredictionSource
if ($currentOption -eq 'None'){
	Set-PSReadLineOption -PredictionSource History
	Write-Host "Auto-complete enabled."
} else {
	Set-PSReadLineOption -PredictionSource None
	Write-Host "Auto-complete disabled."
}

