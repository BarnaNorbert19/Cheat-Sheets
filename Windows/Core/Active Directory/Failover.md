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
