# Add Server to TrustedHosts
Domain membership automatically establishes a trust relationship between the computers in the domain. To manage computers that aren’t in the same domain or are in a workgroup, you must establish that trust yourself by adding the computers you want to manage to the TrustedHosts list on the computer running Server Manager.
Add server to TrustedHosts
```powershell
Set-Item wsman:\localhost\Client\TrustedHosts "computer" -Concatenate -Force
```
List of machines that are in the TrustedHosts
```powershell
Get-Item WSMan:\localhost\Client\TrustedHosts
```
# Add username password
To login with server's local username password
```cmd
cmdkey /add:computer_name /user:Administrator /pass:Password
```
# Add to Server Manager
To add a non-domain joined server or a Workgroup server to Server Manager, you must use DNS or Import option in the Add Servers Wizard.
[![Add DNS to server manager](https://www.jorgebernhardt.com/wp-content/uploads/2018/08/add-server.SM_.png "Add DNS to server manager")](https://www.jorgebernhardt.com/wp-content/uploads/2018/08/add-server.SM_.png "Add DNS to server manager")
### Remove cmdkey
```cmd
cmdkey /delete:computer_name
```
### Remove TrustedHost
[Script](https://github.com/BarnaNorbert19/Cheat-Sheets/blob/main/Windows/Scripts/TrustedHost.psm1 "Script")
### Remove all TrustedHosts
```powershell
Clear-Item WSMan:\localhost\Client\TrustedHosts
```
