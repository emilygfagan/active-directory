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

I edited the GPO and navigated to `Computer Configuration > Windows Settings > Security Settings > Local Policies > User Rights Assignment`. I enabled `Deny log on locally` and 'Deny log on through Remote Desktop Services` for the group `Domain Users`. Adding this group will not affect the active users in other OUs unless they are in the `DisabledAccounts` OU.     

![image2](images/DenyLogin.png)     


