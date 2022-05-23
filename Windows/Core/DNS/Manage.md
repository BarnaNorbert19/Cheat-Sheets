# Add DNS record
```powershell
Add-DnsServerResourceRecord -ZoneName "domain.name" -A -Name "dns_name" -AllowUpdateAny -IPv4Address "192.168.8.3" -TimeToLive 01:00:00 -AgeRecord 
```
# Check DNS record
```powershell
Get-DnsServerResourceRecord -ZoneName "domain.name" -RRType "A" 
```
# Remove DNS record
```powershell
Remove-DnsServerResourceRecord -ZoneName "domain.name" -RRType "A" -Name "dns_name" 
```
