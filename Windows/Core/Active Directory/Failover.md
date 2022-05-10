# Install AD
```powershell
Add-WindowsFeature AD-Domain-Services
```
# Create AD failover
```powershell
$Username  = "DOMAINHERE\Administrator"
$SecurePassword  = ConvertTo-SecureString "PWDHERE" -Asplaintext -Force
$credentials = New-Object System.Management.Automation.PSCredential($Username, $SecurePassword)
Install-ADDSDomainController -CreateDnsDelegation:$false -DatabasePath 'C:\Windows\NTDS' -DomainName 'DOMAIHERE' -InstallDns:$true -LogPath 'C:\Windows\NTDS' -NoGlobalCatalog:$false -SiteName 'Default-First-Site-Name' -SysvolPath 'C:\Windows\SYSVOL' -NoRebootOnCompletion:$true -Force:$true -Credential $credentials
```
# DNS forwarder
```powershell
Set-DnsServerForwarder -IPAddress 8.8.8.8
```
# Install DHCP
```powershell
Install-WindowsFeature DHCP -IncludeManagementTools
```
# Set DHCP scope
Change domain.name at ```-dnsdomain```
```powershell
Set-DHCPServerV4OptionValue -dnsdomain domain.name -dnsserver 192.168.8.1, 192.168.8.2 -router 192.168.8.254
```
# Bind to domain
```powershell
Add-DHCPServerInDC -dnsname computer_name.domain.name
```
# Create DHCP failover
```powershell
Add-DhcpServerv4Failover -ComputerName "winad. szamonker.tl " -PartnerServer "winadtart. szamonker.tl" -Name "winad_winadtart_Hot_standby" -ServerRole Standby -ReservePercent 10 -MaxClientLeadTime 1:00:00 -StateSwitchInterval 00:45:00 -ScopeId 192.168.8.0 -SharedSecret "Pa$$w0rd”
```
