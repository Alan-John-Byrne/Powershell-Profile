# Initial Setup:
$currentDrive = $PWD.Drive.Name
$currentLocation = Get-Location
# Different Parts of the prompt (each 'Write-Host' is a different segment of the prompt.)
if ($currentDrive -eq 'C') {
    # Steps needed prior for drive C:
    $indexOfChar = $PWD.Path.IndexOf("\", $PWD.Path.IndexOf("\") + 1)
    $userNameFromPath = $PWD.Path.Substring($indexOfChar + 1)
    $indexOfUsername = $currentLocation.Path.IndexOf($userNameFromPath)
    $currentPath = $currentLocation.Path.Substring($indexOfUsername)
    # Check for if the username is in the current path, otherwise we are in root.
    if ($PWD.Path.Contains($(get-username))) {
        Write-Host "$currentDrive`:\\ " -ForegroundColor Green -NoNewline
        Write-Host "@ User" -ForegroundColor Gray -NoNewline
        Write-Host " -> " -ForegroundColor Yellow -NoNewline
        Write-Host "$currentPath" -ForegroundColor Cyan -NoNewline # Username in path (Necessary)
    }
    else {
        $path = "$currentDrive`:\\ ~ root" + $PWD.Path.Insert(2, "\")
        Write-Host "$($path.Substring(0, 11)) " -ForegroundColor Green -NoNewline
        Write-Host "$($path.Substring(14))" -ForegroundColor Cyan -NoNewline
    }
}
else {
    $indexOfChar = $currentLocation.Path.IndexOf("\")
    $currentPath = $currentLocation.Path.Substring($indexOfChar + 1)
    if ($currentPath) {
        Write-Host "$currentDrive`:\\ ~ root " -ForegroundColor Green -NoNewline
        Write-Host "\$currentPath" -ForegroundColor Cyan -NoNewline
    }
    else {
        Write-Host "$currentDrive`:\\ ~ root" -ForegroundColor Green -NoNewline
    }
}
# Nice little design:
Write-Host " >>" -ForegroundColor Blue -NoNewline