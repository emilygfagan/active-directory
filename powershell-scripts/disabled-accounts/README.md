# Disabling User Accounts Automation in PowerShell

My next idea for this Active Directory lab was to create an automation in PowerShell that will disable user accounts.      


## Goals

My script automates the following:
1. Move user to a `DisabledAccounts` OU
2. Disable the user account
3. Remove all group memberships
4. Move their home directory and archive data
5. Reset critical properties


## Steps

I created a dedicated Termination OU called `DisabledAccounts` that is kept outside normal active user OUs.     

![image1](images/DisabledAccounts.png)     


For extra security, I wanted to make sure that my terminated users are unable to login locally and unable to login through Remote Desktop Services. In Group Policy Management Editor, I navigated to my `DisabledAccounts` OU and created a new GPO called `Disabled Accounts Lockdown`.      

I edited the GPO and navigated to `Computer Configuration > Windows Settings > Security Settings > Local Policies > User Rights Assignment`.      

I enabled `Deny log on locally` and `Deny log on through Remote Desktop Services` for the group `Domain Users`. Adding this group will not affect the active users in other OUs unless they are in the `DisabledAccounts` OU.    
      

![image2](images/DenyLogin.png)     


I created a base code that prompts for username, returns the user information, confirms with the host whether they want to delete the account, removes group memberships, disables the user account and moves it to the `DisabledAccounts` OU, updates the AD description with the date moved, archives the home directory, and logs the entry to a csv file on the DC01 desktop.     

For testing purposes, I made the password _Disabled123!_, but for best security practices in real-life scenarios, I would have written something like this:     

```powershell
# Generate random password (12 characters)
Add-Type -AssemblyName System.Web
$newPassword = [System.Web.Security.Membership]::GeneratePassword(12, 2)
Set-ADAccountPassword -Identity $user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $newPassword -Force)
```

For testing my script, I decided to test Chad Lee's account, `clee`. I received an error in the code, but it said that it had been run successfully:     

![image3](cleeDisable.png)     

I decided to investigate to see what the problem could be.      
