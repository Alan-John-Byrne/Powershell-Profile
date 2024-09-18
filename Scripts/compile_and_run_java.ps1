param (
    [string]$FullPackagePath #e.g., java_code.topics.polymorphism.Example
    )
# Split on the last '.' to separate the main class and package path.
  $LastDotIndex = $FullPackagePath.LastIndexOf('.')
$PackagePath = $FullPackagePath.Substring(0, $LastDotIndex)
  $MainClass = $FullPackagePath.Substring($LastDotIndex + 1) # One parameter, go from there to the end of the string.

# Extract directory and class name from the provided file path.
  $Directory = $PackagePath -replace '\.', '/'

# Compile all java files in the specified directory.
  javac "$Directory/*.java"

# If compilation succeeds, run the Java program.
  if($?){ # NOTE: '$?' stores the status of previously run command.
    java "$PackagePath.$MainClass"
  } else {
    Write-Host "Compilation failed."
  }
