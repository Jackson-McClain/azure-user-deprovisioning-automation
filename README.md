# Azure AD User Deprovisioning Script

This PowerShell script securely offboards users from Microsoft Entra ID (Azure AD). It disables accounts, removes group memberships, resets passwords, and logs all activity for audit purposes.

## 💡 Features
- Reads a list of usernames from CSV
- Disables user accounts
- Removes users from all security groups
- Resets passwords
- Logs actions to a file

## 🧪 Sample Input: `inactive_users.csv`
```csv
Username
cnguyen
gholt
kshaw
nchen
qbennett
usingh
yali
