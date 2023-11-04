<#
.SYNOPSIS
This script connects to Azure AD and lists users with privileged roles.

.DESCRIPTION
Utilizes the AzureAD or the Az PowerShell module to list users having any of the predefined admin roles.

.PARAMETER AdminEmail
The email address of the admin account with the necessary permissions to query Azure AD.

.EXAMPLE
.\ListPrivilegedUsers.ps1 -AdminEmail "admin@example.com"

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

# Get predefined admin roles
$adminRoles = Get-AzureADSubscribedSku | Where-Object {$_.PreAssignedPlans.PreAssignedPlanId -ne $null} | Select-Object -ExpandProperty PreAssignedPlans

# Loop through each role and list the users
foreach ($role in $adminRoles) {
    $roleMembers = Get-AzureADDirectoryRole | Where-Object {$_.ObjectId -eq $role.ObjectId} | Get-AzureADDirectoryRoleMember
    Write-Host "Users with $($role.DisplayName) rights:"
    $roleMembers | ForEach-Object { Write-Host $_.DisplayName }
}

# Disconnect from Azure AD
Disconnect-AzureAD
