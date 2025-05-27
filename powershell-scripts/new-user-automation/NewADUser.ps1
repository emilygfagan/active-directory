# NewADUser.ps1

# Import AD module
Import-Module ActiveDirectory

do {

    # Prompt for input
    $FirstName = Read-Host "Enter the user's first name"
    $LastName = Read-Host "Enter the user's last name"
    $Department = Read-Host "Enter the department (e.g., HR, IT, Sales)"
    $Department = $Department.ToUpper()
    $JobTitle = Read-Host "Enter the user's job title"

    # Confirm user input
    Write-Host "You entered:"
    Write-Host "First Name: $FirstName"
    Write-Host "Last Name:  $LastName"
    Write-Host "Department: $Department"
    Write-Host "Job Title:  $JobTitle"

    $Confirm = (Read-Host "Is this information correct? (Y/N)").ToUpper()
    if ($Confirm -ne "Y") {
        Write-Host "Aborting this user entry. Please re-enter the information."
        continue # Skip to next loop iteration
    }

    # Build username and display name
    $BaseUsername = ($FirstName.Substring(0,1) + $LastName).ToLower()
    $Username = $BaseUsername
    $DisplayName = "$FirstName $LastName"
    $UPN = "$Username@fagan.local"

    # Check for existing usernames and increment if needed
    $i = 1
    while (Get-ADUser -Filter {SamAccountName -eq $Username}) {
        $i++
        $Username = "$BaseUsername$i"
        $UPN = "$Username@fagan.local"
    }

    # Set temporary password
    $Password = Read-Host "Enter a temporary password" -AsSecureString

    # OU path — change as needed for your domain
    $OU = "OU=Users,OU=$Department,OU=Headquarters,DC=fagan,DC=local"

    # Build description
    $Today = Get-Date -Format 'yyyy-MM-dd'
    $Description = "$JobTitle - added via script on $Today"

  
    # Create the user
    New-ADUser -Name $DisplayName `
               -DisplayName "$FirstName $LastName" `
               -GivenName $FirstName `
               -Surname $LastName `
               -SamAccountName $Username `
               -UserPrincipalName $UPN `
               -Department $Department `
               -Path $OU `
               -AccountPassword $Password `
               -Enabled $true `
               -ChangePasswordAtLogon $true `
               -Description $Description

    # Add to base groups
    Add-ADGroupMember -Identity "AllEmployees" -Members $Username
    Add-ADGroupMember -Identity "Remote Desktop Users" -Members $Username

    # Add to department GPOs
    switch ($Department) {
        "HR" {
            Add-ADGroupMember -Identity "HRConfidential" -Members $Username
        }
        "IT" {
            Add-ADGroupMember -Identity "ITAdmins" -Members $Username
            Add-ADGroupMember -Identity "Administrators" -Members $Username
        }
    }

    Write-Host "User $DisplayName ($Username) created successfully in $Department OU and relevant GPOs."

    # Ask if you want to create another
    $Repeat = (Read-Host "Would you like to add another user? (Y/N)").ToUpper()
} while ($Repeat -eq "Y")
