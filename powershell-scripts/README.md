# PowerShell Automation for Active Directory User Management

This project showcases a PowerShell script developed as part of my Active Directory lab environment. It automates the creation of user accounts in a domain, including user prompts, validation, group assignments, and organizational unit (OU) placement. This script was designed to be both educational and practical, reflecting real-world administrative tasks.     


## Script File
📄 [View the NewADUser.ps1 script](./NewADUser.ps1)


## Purpose

To automate the user creation process in an Active Directory environment using PowerShell. The script:      
- Prompts for first name, last name, department, and job title
- Constructs a unique username
- Adds the user to Active Directory with appropriate attributes
- Assigns them to relevant security groups
- Ensures username uniqueness
- Provides a loop to create multiple users


## Features

- Interactive prompts for user info
- Confirmation of input before proceeding
- Username auto-generation (`first initial` + `last name`)
- Auto-increments username if it already exists (`esmith2`, `esmith3`, etc.)
- Dynamic OU path based on department
- Job title + timestamp stored in user description
- Automatic group assignment based on department
- Repeat loop to add multiple users in one session


## Sample Workflow

1. Run the script in PowerShell ISE or terminal as administrator
2. Enter the user's first name, last name, department, and job title
3. Confirm the info is correct
4. A username is generated, checked for duplicates, and modified if needed
5. The account is created and added to:
   `AllEmployees`
   `Remote Desktop Users`
    if HR - `HRConfidential`     
    if IT - `ITAdmins`, `Administrators`     
6. The admin is prompted to add another user or exit


## Design Choices

### Description Field
- Format: `Job Title - added via script on YYYY-MM-DD`
- Purpose: Track when and why the user was created

### Username Check
Ensures no duplicate usernames exist.
```powershell
$BaseUsername = ($FirstName.Substring(0,1) + $LastName).ToLower()
$Username = $BaseUsername
$i = 1
while (Get-ADUser -Filter {SamAccountName -eq $Username}) {
    $i++
    $Username = "$BaseUsername$i"
}
```


## Additional Commands and Notes

**Check current directory:** `pwd`     

**Change directory:** `cd`     

**Change username in AD:** `Set-ADUser -Identity oldusername -SamAccountName newusername`     
