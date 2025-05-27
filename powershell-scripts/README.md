# PowerShell Automation Scripts

This section includes PowerShell scripts developed to automate Active Directory tasks.     



### 📂[New User Automation Script](./new-user-automation/)     

Automates user account creation with unique username generation, OU placement, and department-based group assignments.     



### 📂[User Rename Script](./rename-user/README.md)     

Updates a user's name and logon credentials following name changes (e.g., marriage or legal updates). Updates CN, SamAccountName, UPN, and other relevant attributes.     



### 📂[User Termination Script](./disabled-accounts/README.md)

Automates the offboarding process by disabling an AD account, removing group memberships, moving the user to a dedicated `DisabledAccounts` OU, resetting their password, archiving their home directory, and logging all actions to a CSV file. Designed to reflect real-world IT offboarding workflows and security best practices.     
