Install IIS with Management Tools
```powershell
Install-WindowsFeature Web-Server –IncludeManagementTools 
```
Install Remote Administration
```powershell
add-WindowsFeature Web-Mgmt-Service
```
```powershell
Import-module servermanager
```
Enable Remote Administration
```powershell
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WebManagement\Server -Name EnableRemoteManagement -Value 1
```
