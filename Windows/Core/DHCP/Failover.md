# Install DHCP tools
```powershell
Install-WindowsFeature DHCP -IncludeManagementTools
```
# Set DNS and Gateway
```powershell
Set-DHCPServerV4OptionValue -dnsdomain szamonker.tl -dnsserver 192.168.8.1, 192.168.8.2 -router 192.168.8.254
```
# Bind DHCP
```powershell
Add-DHCPServerInDC -dnsname winadtart.szamonker.tl
```
# Setup failover
```powershell
Add-DhcpServerv4Failover -ComputerName "current_server_name" -PartnerServer "mainserver_name" -Name "Failover_Hot_standby" -ServerRole Standby -ReservePercent 10 -MaxClientLeadTime 1:00:00 -StateSwitchInterval 00:45:00 -ScopeId 192.168.8.0 -SharedSecret "Pa$$w0rd”
```
# Restart DHCP
```powershell
restart-service dhcpserver
```
