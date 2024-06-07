param (
	[string]$path_filename
)

# Make sure that there is a name given for the new file. (could use '-not' here instead)
if([string]::IsNullorEmpty($path_filename)){
	Write-Host "Please provide a name for the file you are making."
	return
}
if (Test-Path $path_filename) {
	# Update the timestamp if the file exists
	(Get-Item $path_filename).LastWriteTime = Get-Date
} else {
	# Create an empty file if it does not exist
	New-Item $path_filename -ItemType File
}
