# PowerShell Scripts

This repository contains a collection of PowerShell scripts designed to make admin and audit tasks easier.

## Table of Contents

1. [Remove Emails From All Mailboxes](#remove-emails-from-all-mailboxes)
2. [List Privileged Users In Azure AD](#list-privileged-users-in-azure-ad)
3. [List External Users And Permissions](#list-external-users-and-permissions)
4. [Export Azure AD Device Info List](#export-azure-ad-device-info-list)
5. [Audit Teams App Policies](#audit-teams-app-policies)
6. [Audit Teams External Users](#audit-teams-external-users)
7. [Remove User Mailbox Permission](#remove-user-mailbox-permissions)


## Remove Emails From All Mailboxes

### Description

This script connects to Office 365 and removes emails from all mailboxes based on the sender's email address. It's useful for bulk-deleting phishing or spam emails.

### Usage

Soft delete example:
```
.\RemoveEmailsFromAllMailboxes.ps1 -AdminEmail "admin@example.com" -PhishingEmail "phisher@example.com"
```

Hard delete example:
```
.\RemoveEmailsFromAllMailboxes.ps1 -AdminEmail "admin@example.com" -PhishingEmail "phisher@example.com" -PurgeType "HardDelete"
```

### Requirements

- Exchange Online Management module
- Admin account with necessary permissions

## List Privileged Users in Azure AD

### Description

This script connects to Azure AD and lists all users with predefined privileged roles. Useful for auditing purposes or ensuring that only the correct accounts have elevated permissions.

### Usage

```powershell
.\ListPrivilegedUsers.ps1 -AdminEmail "admin@example.com"
```

### Requirements

- AzureAD module
- Admin account with necessary permissions to query Azure AD

## List External Users And Permissions

### Description

This script connects to Azure AD and lists all external or guest users along with the groups they belong to. This can be useful for auditing external access to your resources.

### Usage

```powershell
.\ListExternalUsersAndPermissions.ps1 -AdminEmail "admin@example.com"
```

### Requirements

- AzureAD module
- Admin account with necessary permissions to query Azure AD


## Export Azure AD Device Info List

### Description

This script connects to Azure AD and exports device information for all users into a CSV file. It's useful for inventory management, security audits, or general administrative tasks.

### Usage

```powershell
.\ExportAzureADDeviceInfo.ps1 -AdminEmail "admin@example.com" -OutputFile "C:\path\to\output.csv"
```

### Requirements

- AzureAD module
- Admin account with necessary permissions to query Azure AD and access device information

## Audit Teams App Policies

### Description

This script connects to Microsoft Teams and audits which apps are allowed or installed, along with details on who installed them. Useful for ensuring compliance and security.

### Usage

```powershell
.\AuditTeamsAppPolicies.ps1 -AdminEmail "admin@example.com"
```

### Requirements

- MicrosoftTeams module
- Admin account with necessary permissions to query Teams

## Audit Teams External Users

### Description

This script connects to Microsoft Teams to list all external or guest users, the teams they belong to, and their permissions. Great for auditing external user access.

```powershell
.\AuditTeamsExternalUsers.ps1 -AdminEmail "admin@example.com"
```
### Requirements

- MicrosoftTeams module
- Admin account with necessary permissions to query Teams

## Remove User Mailbox Permission

### Description

This script connects to Exchange Online to find and remove specific permissions (like 'Read' or 'Manage') that a user may have on all mailboxes. Useful for revoking access quickly when a user leaves the organization or changes roles.

### Usage

```powershell
.\RemoveUserMailboxPermission.ps1 -AdminEmail "admin@example.com" -TargetUser "user@example.com"
```
### Requirements

 - Exchange Online Management module
 - Admin account with necessary permissions to modify mailbox permissions
