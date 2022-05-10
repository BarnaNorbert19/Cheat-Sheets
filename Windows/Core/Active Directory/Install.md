# Install AD
```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools 
```
# Build domain
```-DomainMode``` and ```-ForestMode``` are accepting the following values: ```Win2008```, ```Win2008R2```, ```Win2012```, ```Win2012R2```, ```WinThreshold```(Win2016), ```Default```
```powershell
Install-ADDSFOREST -DomainName DOMAIN.NAME -DomainNetbiosName DOMAIN -Force -DomainMode WinThreshold -ForestMode WinThreshold
```
# Uninstall AD
```powershell
Uninstall-ADDSDomainController -DemoteOperationMasterRole:$true -IgnoreLastDnsServerForZone:$true -LastDomainControllerInDomain:$true -RemoveDnsDelegation:$true -RemoveApplicationPartitions:$true -IgnoreLastDCInDomainMismatch:$true -Force:$true
```
