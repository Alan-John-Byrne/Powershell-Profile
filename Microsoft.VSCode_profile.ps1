# Sourcing 'profile.ps1' content.
. $PROFILE

# NOTE: This VSCODE profile is reading from the common 'profile.ps1' profile script.
# The contents in which are copied / duplicated from the main system profile 'Powershell_profile.ps1'.
# This is why we need the vscode-profile alias to 'share' the contents of our system profile,
# with our common profile so that the VS-Code PowerShell extension can read it's contents and be in sync
# with the overall system profile.

# !!Explicit VS-Code Extension support might be redundant!!