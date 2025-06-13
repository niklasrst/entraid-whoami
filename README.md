# EntraId WhoAmI

This repo contains a script to query user details, similar to the legacy `whoami` command from Entra ID.

## How to use it?
Use this command to run the script:
```powershell
.\whoamientraid.ps1
```

## Required MG Graph permissions
- User.Read
    - for reading user details
- User.ReadBasic.All
    - for reading the users groups
- DeviceManagementManagedDevices.Read.All
    - for reading the users devices

## Example output
```
Requested details for firstname.lastname@domain.com from Microsoft Entra ID:

DisplayName            : LASTNAME, FIRSTNAME
EmployeeId             : 12345
Username               : FIRSTNAME.LASTNAME@DOMAIN.TLD
EntraTenantDomain      : COMPANY.onmicrosoft.com
EntraTenantId          : 0000000000-0000000000-0000000000-0000000000
CompanyName            : COMPANYNAME
Department             : DEPARTMENTNAME
ObjectId               : 0000000000-0000-0000-0000-0000000000
SID                    : S-1-12-1-0000000000-0000000000-0000000000-0000000000
UserType               : Member
SyncedAccount          : True
AccountEnabled         : True
UsageLocation          : XY
LastSignIn             : 00/00/0000 00:00:00
PasswordPolicy         : XYZ
EntraIdLicenses        : {000000000-0000-0000-000000000, 000000000-0000-0000-000000000…}
EntraIdEnabledFeatures : {FEATURE1, FEATURE2…}
EntraIdGroups          : {GROUP1, GROUP2…}
Devices                : {DEVICE1, DEVICE2}
MgGraphScope           : {PERMISSION1.ReadWrite.All, PERMISSION2.Read.All…}
```

The script will leave a variable called `$whoamiEntraId` after it executed in the current session. You can use this variable to dot trough the values and work with the values.
For examlple `$whoamiEntraId.Username` would return `FIRSTNAME.LASTNAME@DOMAIN.TLD` in the example above.

## 🤝 Contributing

Before making your first contribution please see the following guidelines:
1. [Semantic Commit Messages](https://gist.github.com/joshbuchea/6f47e86d2510bce28f8e7f42ae84c716)
1. [Git Tutorials](https://www.youtube.com/playlist?list=PLu-nSsOS6FRIg52MWrd7C_qSnQp3ZoHwW)

---

Made with ❤️ by [Niklas Rast](https://github.com/niklasrst)