# Install IIS tools
```powershell
Install-WindowsFeature Web-Server –IncludeManagementTools
add-WindowsFeature Web-Mgmt-Service
Import-module servermanager
```
# Enable remote management
```powershell
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WebManagement\Server -Name EnableRemoteManagement -Value 1
```
# Restart web management service
```powershell
Net Stop WMSVC
Net Start WMSVC
```
# Auto start at startup
```powershell
Set-Service WMSVC -StartupType Automatic
```
# Restart IIS
```powershell
IISRESET /restart
```
