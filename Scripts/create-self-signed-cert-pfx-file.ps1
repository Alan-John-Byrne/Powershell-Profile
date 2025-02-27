param (
  [string]$SubjectName,
  [System.Security.SecureString]$Password,
  [string]$PfxFilePath
)

# Prepare the commands to run in elevated mode using a seperate process.
$ScriptBlock = {
  # User must enter a password.
  if ($Password.Length -eq 0)
  {
    Write-Host "You must enter a password for the certificate."
    exit
  } 
  # Note: Above is how to check if a secure string is empty.

  # Generate a Self-Signed Certificate
  $cert = New-SelfSignedCertificate -Type CodeSigning -Subject "CN=$SubjectName" -CertStoreLocation "Cert:\CurrentUser\My"
  Write-Host "Self-signed certificate created with Thumbprint: $($cert.Thumbprint)"

  # Note: Commands requiring a password parameter, must be read in via the prompt as a secure string.
  Export-PfxCertificate -Cert "$($cert.PSPath)" -FilePath "$PfxFilePath" -Password $Password 
  Write-Host "`nCertificate exported to: $PfxFilePath `n"

  # Define the path and filename for the output text file
  $outputFileName = "CertificateDetails.txt"
  $outputFilePath = Join-Path (Split-Path -Path $PfxFilePath) $outputFileName

  # Writing non-sensitive details to a text file in the directory of the PFX file
  $outputContent = "Subject Name: $SubjectName`nPFX File Path: $PfxFilePath"
  $outputContent | Out-File -FilePath $outputFilePath 
  Write-Host "Non-sensitive details written to: $outputFilePath `n"

  Read-Host 'Press Enter to continue...'
  exit
}

# Use Start-Process to call this command in an elevated PowerShell process
Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit", "-Command & { $(& $scriptBlock) }" -Verb RunAs -Wait

# Note: The PFX file (also known as a PKCS, for 'Personal Key Cryptography Standards'
# file) is used for storeing private keys, and certificates, and optionally a 
# certificate chain.

# Note2: A PFX / PKCS file is used for securely storing your certificate and private
# keys, which is necessary for signing code. You can also transfer them between 
# machines, or different applications that use the certificate.
