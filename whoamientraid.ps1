<#
.SYNOPSIS
   A script to get user account details similar to whoami or the legacy net user command.

.DESCRIPTION
   This script retrieves user account details from Microsoft Entra ID using Microsoft Graph API.
   It provides information such as display name, employee ID, username, tenant domain, and more.

.EXAMPLE
   .\whoamientraid.ps1

.OUTPUTS
    The script will leave a global variable named `whoamiEntraId` containing a PSCustomObject with the properties.
    You can access it in your PowerShell session using `$whoamiEntraId`.
    If you need to use the output in another script, you can import it using `Import-Variable -Name whoamiEntraId`.
    Also you can dot trough the variable to access the properties, e.g. `$whoamiEntraId.DisplayName`.

.NOTES
    Use this script to interact with Microsoft Entra ID and retrieve user account details.

.LINK
   https://github.com/niklasrst/entraid-whoami

.AUTHOR
   Niklas Rast
#>

#Requires -Module Microsoft.Graph.Authentication

# MGGraph connection
try {
    Connect-MgGraph -NoWelcome
    $mggraphcontext = Get-MgContext

    if (-not ($mggraphcontext.Scopes -contains "User.Read")) {
            Write-Error "The required 'User.Read' permission is missing in the current Microsoft Graph context."
            Disconnect-MgGraph | Out-Null
            exit
        }
}
catch {
    Write-Warning "Failed to connect to MGGraph: $($_.Exception.Message)"
    Disconnect-MgGraph | Out-Null
    exit
}

# Get user details
try {
   $user = (Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/me")
}
catch {
   $user = "null"
}

# Get user groups and devices
try {
   $userGroups = (Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/users/{$($user.id)}/memberOf").value
}
catch {
   $userGroups = "null"
}

# Get user devices
try {
   $userDevices = (Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/managedDevices?`$filter=(userPrincipalName eq '$($user.userPrincipalName)')").value
}
catch {
   $userDevices = "null"
}

$entraIdUser = [PSCustomObject]@{
    DisplayName             = $user.displayName
    EmployeeId              = $user.employeeId
    Username                = $user.userPrincipalName
    EntraTenantDomain       = $user.identities.issuer
    EntraTenantId           = $mggraphcontext.TenantId
    CompanyName             = $user.companyName
    Department              = $user.department
    ObjectId                = $user.id
    SID                     = $user.securityIdentifier
    UserType                = $user.userType
    SyncedAccount           = $user.onPremisesSyncEnabled
    AccountEnabled          = $user.accountEnabled
    UsageLocation           = $user.usageLocation
    LastSignIn              = $user.refreshTokensValidFromDateTime
    PasswordPolicy          = $user.passwordPolicies

    EntraIdLicenses         = $user.assignedLicenses.skuId
    EntraIdEnabledFeatures  = $user.assignedPlans.service
    EntraIdGroups           = $userGroups.displayName

    Devices                 = $userDevices.deviceName

    MgGraphScope            = $mggraphcontext.Scopes

}
Set-Variable -Name "whoamiEntraId" -Value $entraIdUser -Scope Global
$entraIdUser

Disconnect-MgGraph | Out-Null