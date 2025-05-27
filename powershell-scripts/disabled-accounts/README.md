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

![image1](images/image1.png)     
