<#
.SYNOPSIS
This script connects to Azure AD and exports device information for all users to a CSV file.

.DESCRIPTION
Utilizes the AzureAD PowerShell module to fetch detailed device information and saves it to a specified CSV file.

.PARAMETER AdminEmail
The email address of the admin account with the necessary permissions to query Azure AD.

.PARAMETER OutputFile
The path where the CSV file will be saved.

.EXAMPLE
.\ExportAzureADDeviceInfo.ps1 -AdminEmail "admin@example.com" -OutputFile "C:\path\to\output.csv"

.NOTES
1. Make sure you have the required permissions to perform these actions.
#>

# Import AzureAD module if not already imported
if (-Not (Get-Module -ListAvailable -Name AzureAD)) {
    Write-Host "Installing AzureAD module."
    Install-Module -Name AzureAD -Scope CurrentUser -Force -SkipPublisherCheck
}
Import-Module AzureAD

param(
    [string]$AdminEmail,
    [string]$OutputFile
)

# Connect to Azure AD
Connect-AzureAD -Credential (Get-Credential -UserName $AdminEmail -Message "Enter your Azure AD credentials")

# Initialize an empty array to hold the device info
$deviceInfoArray = @()

# Fetch all devices
$devices = Get-AzureADDevice

# Loop through each device to gather information
foreach ($device in $devices) {
    $deviceInfo = [ordered]@{
        "DeviceID"          = $device.ObjectId
        "DeviceName"        = $device.DisplayName
        "OperatingSystem"   = $device.OperatingSystem
        "OSVersion"         = $device.OperatingSystemVersion
        "DeviceTrustLevel"  = $device.DeviceTrustType
        "DeviceJoinType"    = $device.DeviceJoinType
        "LastLogin"         = $device.ApproximateLastLogonTimestamp
        "LoggedinUser"      = $device.LastLoggedOnUserName
        "Manufacturer"      = $device.DeviceManufacturer
        "Model"             = $device.DeviceModel
    }
    
    # Add this device info to the array
    $deviceInfoArray += New-Object PSObject -Property $deviceInfo
}

# Disconnect from Azure AD
Disconnect-AzureAD

# Export to CSV
$deviceInfoArray | Export-Csv -Path $OutputFile -NoTypeInformation
