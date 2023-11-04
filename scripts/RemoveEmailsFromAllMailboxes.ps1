<#
.SYNOPSIS
This script connects to Office 365 and removes emails from all mailboxes based on the sender's email.

.DESCRIPTION
It utilizes the Exchange Online PowerShell module to create a compliance search, runs the search, displays the search summary, and then purges the emails after user confirmation.

.PARAMETER AdminEmail
The email address of the admin account with necessary permissions to run compliance searches.

.PARAMETER PhishingEmail
The email address of the sender whose emails you want to delete.

.PARAMETER PurgeType
Type of deletion to be performed. Options are 'SoftDelete' and 'HardDelete'. Default is 'SoftDelete'.

.EXAMPLE
Soft delete example:
.\RemoveEmailsFromAllMailboxes.ps1 -AdminEmail "admin@example.com" -PhishingEmail "phisher@example.com"

Hard delete example:
.\RemoveEmailsFromAllMailboxes.ps1 -AdminEmail "admin@example.com" -PhishingEmail "phisher@example.com" -PurgeType "HardDelete"

.NOTES
1. Make sure you have the required permissions to perform these actions.

#>

# Check if the ExchangeOnlineManagement module is installed and install if not found.
if (-Not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Write-Host "Installing ExchangeOnlineManagement module."
    Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser -Force -SkipPublisherCheck
}
Import-Module ExchangeOnlineManagement

param(
    [string]$AdminEmail,
    [string]$PhishingEmail,
    [string]$PurgeType = "SoftDelete" # Default is SoftDelete, can be changed to HardDelete
)

function CheckSuccess {
    if ($?) {
        Write-Host "$($MyInvocation.InvocationName) was successful."
    }
    else {
        Write-Host "$($MyInvocation.InvocationName) failed. Exiting."
        exit 1
    }
}

# Connect
Connect-ExchangeOnline -UserPrincipalName $AdminEmail
CheckSuccess

# Generate a timestamp
$timestamp = Get-Date -Format "yyyyMMddHHmmss"

# Create a new compliance search with a unique name
$searchName = "PhishingSearch-$timestamp"
New-ComplianceSearch -Name $searchName -ExchangeLocation "All" -ContentMatchQuery "sender:$PhishingEmail"
CheckSuccess

# Run the compliance search
Start-ComplianceSearch -Identity $searchName
CheckSuccess

# Get the results to show the user
$SearchResult = Get-ComplianceSearch -Identity $searchName

# Display the results
Write-Host "Emails to be deleted: $($SearchResult.Items)"
Write-Host "Total count: $($SearchResult.ItemCount)"

# Confirm deletion
$confirmation = Read-Host "Do you want to proceed with the deletion? (Y/N)"
if ($confirmation -eq 'Y') {
    # Perform action to remove emails based on the compliance search
    New-ComplianceSearchAction -SearchName $searchName -Purge -PurgeType $PurgeType
    CheckSuccess
    Write-Host "Emails deleted successfully with $PurgeType."
}
else {
    Write-Host "Deletion cancelled."
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false
