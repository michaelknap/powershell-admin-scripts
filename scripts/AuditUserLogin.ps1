<#
.SYNOPSIS
    Retrieves and reports user logon, logon failure, and account lockout events from the Security log.

.DESCRIPTION
    This script fetches logon, logon failure, and account lockout events (Event IDs 4624, 4625, 4740) 
    for a specified user from the Security log of a domain controller. It allows filtering events based on
    a specific time frame and can optionally export the results to a CSV file.

.PARAMETER user
    The username for which the logon events are to be fetched.

.PARAMETER days
    The number of days back from the current date to fetch the events.

.PARAMETER csv
    A switch parameter. If set, the output will be saved to a CSV file.

.EXAMPLE
    .\AuditUserLogin.ps1 -user "user1" -days 5
    This example fetches logon events for user 'user1' from the last 5 days and displays them in the console.

.EXAMPLE
    .\AuditUserLogin.ps1 -user "user1" -days 5 -csv
    This example fetches logon events for user 'user1' from the last 5 days and saves them to a CSV file.

.NOTES
    Make sure to run this script with administrative privileges to access Security logs.
#>

param(
    [string]$user,
    [int]$days,
    [switch]$csv
)

$start_date = (Get-Date).AddDays(-$days)
$filter_hash_table = @{
    LogName = 'Security'
    StartTime = $start_date
    Id = 4624, 4625, 4740 # Logon, Logon Failure, and Account Lockout Event IDs
}

# Filter for the specific user
$events = Get-WinEvent -FilterHashtable $filter_hash_table | Where-Object {
    $_.Properties[5].Value -eq $user -or
    $_.Properties[6].Value -eq $user
}

if ($csv.IsPresent) {
    $csv_file_name = "$user" + "_" + "$days.csv"
    $events | Select-Object TimeCreated, Id, LevelDisplayName, Message, @{Name="AccountName"; Expression={$_.Properties[5].Value}}, @{Name="Domain"; Expression={$_.Properties[6].Value}} | Export-Csv -Path $csv_file_name -NoTypeInformation
    Write-Host "Logs saved to $csv_file_name"
} else {
    $events | Format-Table -AutoSize
}
