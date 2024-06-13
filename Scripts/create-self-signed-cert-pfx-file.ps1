param (
		[Parameter(Mandatory=$true)]
		[string]$SubjectName,

		[Parameter(Mandatory=$true)]
		[string]$PfxFilePath
      )

# Generate a Self-Signed Certificate
$cert = New-SelfSignedCertificate -Type CodeSigning -Subject "CN=$SubjectName" -CertStoreLocation "Cert:\CurrentUser\My"
Write-Host "Self-signed certificate created with Thumbprint: $($cert.Thumbprint)"

# Prepare the command to run in elevated mode
$command = @"

Export-PfxCertificate -Cert `"$($cert.PSPath)`" -FilePath `"$PfxFilePath`" -Password (Read-Host 'Enter your password' -AsSecureString) 
Write-Host "Certificate exported to $PfxFilePath"

Read-Host 'Press Enter to continue...'
exit

"@

# Use Start-Process to call this command in an elevated PowerShell process
Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit", "-Command $command" -Verb RunAs -Wait

# Define the path and filename for the output text file
$outputFileName = "CertificateDetails.txt"
$outputFilePath = Join-Path (Split-Path -Path $PfxFilePath) $outputFileName

# Writing non-sensitive details to a text file in the directory of the PFX file
$outputContent = "Subject Name: $SubjectName`nPFX File Path: $PfxFilePath"
$outputContent | Out-File -FilePath $outputFilePath 
Write-Host "Non-sensitive details written to $outputFilePath"

# Note: The PFX file (also known as a PKCS, for 'Personal Key Cryptography Standards'
# file) is used for storeing private keys, and certificates, and optionally a 
# certificate chain.

# Note2: A PFX / PKCS file is used for securely storing your certificate and private
# keys, which is necessary for signing code. You can also transfer them between 
# machines, or different applications that use the certificate.
