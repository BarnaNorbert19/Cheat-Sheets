# Stop default site
```powershell
Stop-Website -Name "Default Web Site"
```
# New virtual site
```powershell
New-WebSite -Name site_name -Port 80 -HostHeader www.site.name -PhysicalPath "c:\folder_path" -Force
```
# Remove virtual site
```powershell
Remove-WebSite -Name site_name
```
