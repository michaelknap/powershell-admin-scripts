<#
.SYNOPSIS
This script audits the allowed or installed apps in Teams.

.DESCRIPTION
Utilizes the Teams PowerShell module to list allowed or installed apps and their details.

.PARAMETER AdminEmail
The email address of the admin account with the necessary permissions to query Teams.

.EXAMPLE
.\AuditTeamsApps.ps1 -AdminEmail "admin@example.com"

.NOTES
1. Make sure you have the required permissions to perform these actions.
#>

# Check if the MicrosoftTeams module is installed and install if not found.
if (-Not (Get-Module -ListAvailable -Name MicrosoftTeams)) {
    Write-Host "Installing MicrosoftTeams module."
    Install-Module -Name MicrosoftTeams -Scope CurrentUser -Force -SkipPublisherCheck
}

# Import the Teams module
Import-Module MicrosoftTeams

param(
    [string]$AdminEmail
)

# Connect to Teams
Connect-MicrosoftTeams -Credential (Get-Credential -UserName $AdminEmail -Message "Enter your Teams credentials")

# List all Teams apps
$teamsApps = Get-TeamsApp
$teamsApps | ForEach-Object {
    Write-Host "App Name: $($_.DisplayName), App ID: $($_.Id), Installed By: TBD"
}

# Disconnect from MicrosoftTeams
Disconnect-MicrosoftTeams
