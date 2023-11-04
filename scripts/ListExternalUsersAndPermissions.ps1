<#
.SYNOPSIS
This script connects to Azure AD and lists all external or guest users along with their group memberships.

.DESCRIPTION
Utilizes the AzureAD PowerShell module to list all external or guest users and the groups they belong to.

.PARAMETER AdminEmail
The email address of the admin account with the necessary permissions to query Azure AD.

.EXAMPLE
.\ListExternalUsersAndPermissions.ps1 -AdminEmail "admin@example.com"

.NOTES
1. Make sure you have the required permissions to perform these actions.
#>

# Check if the AzureAD module is installed and install if not found.
if (-Not (Get-Module -ListAvailable -Name AzureAD)) {
    Write-Host "Installing AzureAD module."
    Install-Module -Name AzureAD -Scope CurrentUser -Force -SkipPublisherCheck
}
Import-Module AzureAD


param(
    [string]$AdminEmail
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
Connect-AzureAD -Credential (Get-Credential -UserName $AdminEmail -Message "Enter your Azure AD credentials")
CheckSuccess

# Fetch all external or guest users
$externalUsers = Get-AzureADUser -Filter "userType eq 'Guest'"

# Loop through each external user and list their group memberships
foreach ($user in $externalUsers) {
    Write-Host "User: $($user.DisplayName)"
    $groups = Get-AzureADUserMembership -ObjectId $user.ObjectId
    Write-Host "Belongs to the following groups:"
    $groups | ForEach-Object { Write-Host $_.DisplayName }
    Write-Host "---"
}

# Disconnect from Azure AD
Disconnect-AzureAD