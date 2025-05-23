# RenameADUser.ps1

# Load the Active Directory Module
Import-Module ActiveDirectory

# Function to prompt for user input and return a valid AD user
function Get-ValidUser {
    while ($true) {
        $CurrentUsername = Read-Host "Enter the current username (SamAccountName) of the user"
        $user = Get-ADUser -Identity $CurrentUsername -Properties DisplayName, SamAccountName, UserPrincipalName, GivenName, Surname -ErrorAction SilentlyContinue

        if ($user) {
            return $user
        } else {
            Write-Host "User '$CurrentUsername' not found." -ForegroundColor Red
            $tryAgain = Read-Host "Would you like to try a different username? (Y/N)"
            if ($tryAgain -notin @("Y", "y")) {
                Write-Host "Exiting script." -ForegroundColor Yellow
                exit
            }
        }
    }
}


# Get target user
$user = Get-ValidUser
$oldSamAccountName = $user.SamAccountName

# Prompt for new name
$NewFirstName = Read-Host "Enter new first name"
$NewLastName = Read-Host "Enter new last name"

# Build new values
$newDisplayName = "$NewFirstName $NewLastName"
$newSamAccountName = ($NewFirstName.Substring(0,1) + $NewLastName).ToLower()
$newUserPrincipalName = "$newSamAccountName@fagan.local"

# Check if new username is already in use
if (Get-ADUser -Filter { SamAccountName -eq $newSamAccountName }) {
    Write-Host "The username '$newSamAccountName' already exists. Rename aborted." -ForegroundColor Red
    exit
}


try {
    # Rename AD object
    Rename-ADObject -Identity $user.DistinguishedName -NewName $newDisplayName

    # Refresh user object with updated DistinguishedName
    $user = Get-ADUser -Identity $oldSamAccountName -Properties DisplayName, SamAccountName, UserPrincipalName, GivenName, Surname

    # Update user attributes
    Set-ADUser -Identity $user.DistinguishedName `
        -GivenName $NewFirstName `
        -Surname $NewLastName `
        -DisplayName $newDisplayName `
        -SamAccountName $newSamAccountName `
        -UserPrincipalName $newUserPrincipalName

    Write-Host "`n User '$oldSamAccountName' renamed successfully to '$newSamAccountName'"
    Write-Host "  New Display Name: $newDisplayName"
    Write-Host "  New UPN: $newUserPrincipalName"
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
}
