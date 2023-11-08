# Send-GraphAPIEmail
This PowerShell script uses Microsoft Graph API to send emails via a shared Mailbox.

## Prerequisites
Before you run this script, you'll need to have the following:

- PowerShell 5.1 or higher.
- An Azure AD application with the necessary API permissions to send emails via Microsoft Graph.
- The Tenant ID, Client ID, and a valid Client Secret for the Azure AD application.



### Shared Mailbox
For every use-case, we need to create a distinctive Shared Mailbox via Exchange Admin Center.
 
### Azure AD App Registration
For every use-case, we need to create a distinctive Azure AD App registration, so that we can keep the scope of permissions limited.
This Script requires the API Permissions "Mail.Send" for it to function.

While that API Permission would allow to send E-Mails from EVERY Mailbox in our tenant, the scope of these permissions has been limited trough the following mitiation:
- Created a Mail-enabled Security Group called "securitywrapper.usecase@company.ch"
- Addedd the shared Mailbox we created as a member of that Mail enabled security group
- Created a new Exchange Online Application Access Policy:
```powershell
Connect-ExchangeOnline
New-ApplicationAccessPolicy -AccessRight RestrictAccess -AppId "APPLICATIONID" -PolicyScopeGroupId "NAMEOFMAILENABLEDSECURITYGROUP" -Description "Restrict Application Registration for sending and reading email"
```

## Usage
Make sure you provide the values for the authentication part within the Script. 
These are:
- The Tenant ID
- Client ID
- a valid Client Secret for the Azure AD application.
