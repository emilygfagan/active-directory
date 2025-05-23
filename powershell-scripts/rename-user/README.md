# Active Directory User Rename Script in PowerShell

This PowerShell script automates the process of renaming Active Directory user accounts in response to name changes — such as after marriage or divorce. It streamlines the update of key identity attributes including the user's full name, display name, logon name (sAMAccountName), and User Principal Name (UPN).      

This tool is designed to reflect real-world IT support tasks, where consistent and accurate user records are essential for both user experience and security.   


## Script File
📄[View the final RenameADUser.ps1 file]


## Features

- Prompts for the user’s current username and new first and last names.
- Updates the `Name`, `DisplayName`, `GivenName`, and `Surname` fields in Active Directory.
- Renames the `sAMAccountName` and `UserPrincipalName` to match the new name.
- Automatically generates the new username based on the updated first and last names.
- Logs success or error messages for administrator awareness.


## Skills Demonstrated

- PowerShell scripting
- Active Directory User Management
- Identity and Access Management (IAM)
- Realistic IT support automation
- Error handling and validation
