# Install AD
```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools 
```
# Build domain
```-DomainMode```and```-ForestMode```are accepting the following values: ```Win2008```,```Win2008R2```,```Win2012```,```Win2012R2```,```WinThreshold```(Win2016),```Default```
```powershell
Install-ADDSFOREST -DomainName LOCAL.HOME -DomainNetbiosName LOCAL.HOME -Force -DomainMode WinThreshold -ForestMode WinThreshold
```
# Create group
```powershell
New-ADgroup –Name "webfejlesztok" -GroupScope "Global"
```
