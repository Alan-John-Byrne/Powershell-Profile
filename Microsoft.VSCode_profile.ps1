# Sourcing 'profile.ps1' content.
. $profile

# NOTE: This VSCODE profile is reading from the common 'profile.ps1' profile script.
# The contents in which are copied / duplicated from the current user profile 'Powershell_profile.ps1'. 
# This is why we need the vscode-profile alias to 'share' the contents of our system profile,
# with our common profile so that the VS-Code PowerShell extension can read it's contents and be in
# sync with the current user profile.

# WARN: !!Explicit VS-Code Extension support might be redundant!!
