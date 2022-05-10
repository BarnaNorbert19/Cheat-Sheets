# Create user
``` -SamAccountName ```  is the name we can use to reference the object
```powershell
New-ADUser -SamAccountName "username" -UserPrincipalName "principalname@domain.name" -Name "full name" -Enabled $True -ChangePasswordAtLogon $False -DisplayName "full name" -Department "dep" -Path "CN=Users, DC=DOMAIN, DC=NAME" -AccountPassword (convertto-securestring "Aa123456" -AsPlainText -Force)
```
# Create group
```powershell
New-ADgroup –Name "grp_name" -GroupScope "Global"
```
# Add user to a group
```powershell
Add-ADGroupMember -Identity "grp_name" -Members "user","user"
```
# List users
```powershell
Get-ADuser
```
# List groups
```powershell
Get-ADGroup
```
# List group members
```powershell
Get-ADGroupMember -Idnetity "grp_name"
```
