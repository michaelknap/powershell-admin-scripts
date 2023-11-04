<#
.SYNOPSIS
This script connects to Exchange Online and removes a specific user's mailbox permissions across all mailboxes.

.DESCRIPTION
The script enumerates all mailboxes in Exchange Online, identifies any permissions that the specified user has, and removes those permissions.

.PARAMETER AdminEmail
The email address of the admin account with the necessary permissions to query Exchange Online.

.PARAMETER UserToRemove
The email address of the user whose permissions should be removed across all mailboxes.

.EXAMPLE
.\RemoveUserMailboxPermissions.ps1 -AdminEmail "admin@example.com" -UserToRemove "user@example.com"

.NOTES
1. Make sure you have the required permissions to perform these actions.
#>

# Check if the ExchangeOnlineManagement module is installed, and install it if not found.
if (-Not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Write-Host "Installing ExchangeOnlineManagement module."
    Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser -Force -SkipPublisherCheck
}
Import-Module ExchangeOnlineManagement

param(
    [string]$AdminEmail,
    [string]$UserToRemove
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

# Connect to Exchange Online
Connect-ExchangeOnline -UserPrincipalName $AdminEmail
CheckSuccess

# Get all mailboxes
$mailboxes = Get-Mailbox -ResultSize Unlimited

# Loop through each mailbox to remove permissions
foreach ($mailbox in $mailboxes) {
    $permissions = Get-MailboxPermission -Identity $mailbox.Identity

    foreach ($permission in $permissions) {
        if ($permission.User -eq $UserToRemove) {
            Write-Host "Removing permissions for $UserToRemove from mailbox $($mailbox.DisplayName)"
            Remove-MailboxPermission -Identity $mailbox.Identity -User $UserToRemove -Confirm:$false
        }
    }
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false
