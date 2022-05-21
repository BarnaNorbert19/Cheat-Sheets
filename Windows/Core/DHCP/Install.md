# Install DHCP
```powershell
Install-WindowsFeature DHCP -IncludeManagementTools
```
# Configure DHCP scope
```powershell
Add-DHCPServerV4Scope -name "scope_name" -startrange 192.168.8.1 -endrange 192.168.8.100 -subnetmask 255.255.255.0
```
# Set DNS server(s) and router
```powershell
Set-DHCPServerV4OptionValue -dnsdomain domain.name -dnsserver 192.168.8.1, 192.168.8.2 -router 192.168.8.254
```
# Bind DHCP 
```powershell
Add-DHCPServerInDC -dnsname pcname.domain.name
```
# Restart DHCP
```cmd
restart-service dhcpserver
```
