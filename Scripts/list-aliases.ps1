$profileContent = Get-Content -Path $(get-prof)
$lengthOfFile = $profileContent.Length - 1
$matchingLine = $profileContent | Select-String -Pattern "ALL ALIASES"
$startLineIndex = $matchingLine.LineNumber - 1
$profileContent[$startLineIndex..$lengthOfFile]
