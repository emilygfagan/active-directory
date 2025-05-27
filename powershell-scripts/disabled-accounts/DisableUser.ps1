# DisableUser.ps1
Import-Module ActiveDirectory

# Prompt for username (SamAccountName)
$username = Read-Host "Enter the SamAccountName of the user to disable"

# Get user object and key properties
$user = Get-ADUser -Identity $username -Properties DisplayName, DistinguishedName, MemberOf, Department, Description

if (-not $user) {
    Write-Host "User '$username' not found." -ForegroundColor Red
    exit
}

# Show user info and confirm
Write-Host "User found: $($user.DisplayName)"
Write-Host "Distinguished Name: $($user.DistinguishedName)"
Write-Host "Department: $($user.Department)"
Write-Host "Groups:"
$user.MemberOf | ForEach-Object { Get-ADGroup $_ | Select -ExpandProperty Name }

$confirm = Read-Host "Do you want to continue disabling this account? (Y/N)"
if ($confirm -notin @("Y", "y")) {
    Write-Host "Aborting." -ForegroundColor Yellow
    exit
}

# Get original group names before removal
$originalGroupDNs = $user.MemberOf
$removedGroups = @()

foreach ($groupDN in $originalGroupDNs) {
    $groupName = (Get-ADGroup $groupDN).Name
    Remove-ADGroupMember -Identity $groupName -Members $user -Confirm:$false
    $removedGroups += $groupName
}

# Disable account
Disable-ADAccount -Identity $user

# For testing purposes, we're using a known password to allow logon if needed.
$newPassword = "Disabled123!"
Set-ADAccountPassword -Identity $user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $newPassword -Force)

# Move user to DisabledAccounts OU
$targetOU = "OU=DisabledAccounts,DC=fagan,DC=local"
Move-ADObject -Identity $user.DistinguishedName -TargetPath $targetOU

#Refresh user object after move
$user = Get-ADUser -Identity $username

# Update AD description with disable date
$date = Get-Date -Format "yyyy-MM-dd"
Set-ADUser -Identity $user -Description "Disabled account on $date"

# Archive home directory (if exists)
$homeSource = "\\server\users\$username"
$homeArchive = "\\server\archives\$username"

if (Test-Path $homeSource) {
    Move-Item -Path $homeSource -Destination $homeArchive
    $archiveStatus = "Archived to $homeArchive"
} else {
    $archiveStatus = "No home directory found"
}

# Logging: Create folder on Desktop and log to CSV
$desktop = [Environment]::GetFolderPath("Desktop")
$logFolder = "$desktop\TerminationLogs"
$logPath = "$logFolder\terminated-users.csv"

# Create the folder if it doesn't exist
if (!(Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory | Out-Null
}

# Log entry
$logLine = [PSCustomObject]@{
    Username       = $username
    DisplayName    = $user.DisplayName
    DisabledOn     = $date
    DescriptionSet = "Disabled account on $date"
    GroupsRemoved  = $removedGroups -join "; "
    PasswordReset  = "Yes - Testing mode"
    Archived       = $archiveStatus
}

$logLine | Export-Csv -Path $logPath -Append -NoTypeInformation

Write-Host "`nUser $username has been terminated and logged successfully." -ForegroundColor Green
