<#
.SYNOPSIS
This script audits guest users and their permissions in Teams.

.DESCRIPTION
Utilizes the Teams PowerShell module to list external or guest users and the teams they are part of.

.PARAMETER AdminEmail
The email address of the admin account with the necessary permissions to query Teams.

.EXAMPLE
.\AuditTeamsExternalUsers.ps1 -AdminEmail "admin@example.com"

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

# Get Teams
$allTeams = Get-Team

# Loop through each Team and get external users
foreach ($team in $allTeams) {
    $teamMembers = Get-TeamUser -GroupId $team.GroupId
    $externalMembers = $teamMembers | Where-Object {$_.UserType -eq 'Guest'}
    
    $externalMembers | ForEach-Object {
        Write-Host "External User: $($_.Name), Team: $($team.DisplayName), Role: $($_.Role)"
    }
}

# Disconnect from MicrosoftTeams
Disconnect-MicrosoftTeams
