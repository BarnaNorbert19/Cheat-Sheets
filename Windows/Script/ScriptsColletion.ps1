<#
.SYNOPSIS
    Auto installs Active Directory.
.DESCRIPTION
    Auto installs Active Directory and configures it to use the specified domain.
.EXAMPLE
    AutoInstallAD -DomainName 'DOMAIN.NAME' -DomainNetbiosName 'DOMAIN' -DomainMode 'Win2008R2' -ForestMode 'Win2008R2'
#>

function AutoInstallAD {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $DomainName,

        
        [Parameter(Mandatory = $true)]
        [string]
        $DomainNetbiosName,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Win2008', 'Win2008R2', 'Win2012', 'Win2012R2', 'WinThreshold', 'Default')]
        [string]
        $DomainMode = 'WinThreshold',

        [Parameter(Mandatory = $false)]
        [ValidateSet('Win2008', 'Win2008R2', 'Win2012', 'Win2012R2', 'WinThreshold', 'Default')]
        [string]
        $ForestMode = 'WinThreshold'
    )
    
    begin {
        Write-Warning("Turning firewall off...")
        netsh advfirewall set allprofiles state off
    }
    
    process {
        try {
            Write-Output("Installing Active Directory Services...")
            Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
            Write-Output("Configuring Active Directory...")
            Install-ADDSFOREST -DomainName $DomainName -DomainNetbiosName $DomainNetbiosName -Force -DomainMode $DomainMode -ForestMode $ForestMode
        }
        catch {
            Write-Host "An error occurred (at " + $_.ScriptStackTrace + "):"
            Write-Host $_
        }
    
    }
    
    end {
        Write-Warning("Turning firewall on...")
        netsh advfirewall set allprofiles state on
    }
}

<#
.SYNOPSIS
    Auto installs Active Directory Failover.
.DESCRIPTION
    Auto installs Active Directory Failover and configures it to use the specified domain.
.EXAMPLE
    AutoInstallFailoverAD -Username DOMAIN\Administrator -Password 'Aa123456' -DomainName 'domain.name' -Dns $true -ForwarderIp 8.8.8.8
#>

function AutoInstallFailoverAD {
    [CmdletBinding()]
    param (
        # Username for the domain controller e.g. DOMAIN\Administrator
        [Parameter(Mandatory = $true)]
        [string]
        $Username,

        # Password for the domain controller.
        [Parameter(Mandatory = $true)]
        [SecureString]
        $Password,

        [Parameter(Mandatory = $true)]
        [string]
        $DomainName,

        # If you want to have backup DNS server set this to true.
        [Parameter(Mandatory = $false)]
        [bool]
        $Dns = $false,

        # DNS forwarder IP address.
        [Parameter(Mandatory = $false)]
        [ipaddress]
        $ForwarderIp = 8.8.8.8
    )
    
    begin {
        Write-Warning("Turning firewall off...")
        netsh advfirewall set allprofiles state off 
    }
    
    process {
        try {
            Write-Output("Installing Active Directory Services...")
            Add-WindowsFeature AD-Domain-Services
        
            $credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)
            Write-Output("Configuring Active Directory Failover...")
            Install-ADDSDomainController -CreateDnsDelegation:$false -DatabasePath 'C:\Windows\NTDS' -DomainName $DomainName -InstallDns:$true -LogPath 'C:\Windows\NTDS' -NoGlobalCatalog:$false -SiteName 'Default-First-Site-Name' -SysvolPath 'C:\Windows\SYSVOL' -NoRebootOnCompletion:$true -Force:$true -Credential $credentials

            if ($Dns) {
                Write-Output("Setting DNS forwarder...")
                Set-DnsServerForwarder -IPAddress $ForwarderIp
            }
        }
        catch {
            Write-Host "An error occurred (at " + $_.ScriptStackTrace + "):"
            Write-Host $_
        }
    }
    
    end {
        Write-Warning("Turning firewall on...")
        netsh advfirewall set allprofiles state on 
    }
}

<#
.SYNOPSIS
    Auto installs DHCP.
.DESCRIPTION
    Auto installs DHCP with the specified range.
.EXAMPLE
    AutoInstallDHCP -ScopeName 'scp1' -Dnsname pcname.domain.name -StartRange 192.168.1.10 -EndRange 192.168.1.250 -SubnetMask 255.255.255.0 -RouterIp 192.168.1.254 $DnsServers 192.168.1.1, 192.168.1.2
#>

function AutoInstallDHCP {
    [CmdletBinding()]
    param (
        # Name of the DHCP scope.
        [Parameter(Mandatory = $false)]
        [string]
        $ScopeName = 'scp1',

        # DNS name of the current server
        [Parameter(Mandatory = $true)]
        [string]
        $Dnsname,

        # Start of the dhcp range.
        [Parameter(Mandatory = $true)]
        [ipaddress]
        $StartRange,

        # End of the dhcp range.
        [Parameter(Mandatory = $true)]
        [ipaddress]
        $EndRange,

        # DHCP range subnet mask.
        [Parameter(Mandatory = $true)]
        [ipaddress]
        $SubnetMask,

        # Router IP address.
        [Parameter(Mandatory = $true)]
        [ipaddress]
        $RouterIp,

        [Parameter(Mandatory = $true)]
        [ipaddress[]]
        $DnsServers
    )
    
    begin {
        Write-Warning("Turning firewall off...")
        netsh advfirewall set allprofiles state off
    }
    
    process {
        try {
            Write-Output("Installing DHCP Services...")
            Install-WindowsFeature DHCP -IncludeManagementTools
            Write-Output("Creating DHCP scope...")
            Add-DHCPServerV4Scope -name $ScopeName -startrange $StartRange -endrange $EndRange -subnetmask $SubnetMask
            Write-Output("Binding DHCP to Domain...")
            Set-DHCPServerV4OptionValue -dnsdomain $DomainName -dnsserver $DnsServers -router $RouterIp
            Write-Output("Configuring DNS...")
            Add-DHCPServerInDC -dnsname $Dnsname
            Write-Output("Restarting DHCP...")
            restart-service dhcpserver
        }
        catch {
            Write-Host "An error occurred (at " + $_.ScriptStackTrace + "):"
            Write-Host $_
        }
    }
    
    end {
        Write-Warning("Turning firewall on...")
        netsh advfirewall set allprofiles state on
    }
}

<#
.SYNOPSIS
    Auto installs DHCP failover.
.DESCRIPTION
    Auto installs DHCP failover with the specified range, that takes over the DHCP role if the main server fails to provide functionality.
.EXAMPLE
    AutoInstallDHCPFailover -DomainName "domain.name" -DnsServers 192.168.1.1, 192.168.1.2 -Router 192.168.1.254 -DnsName currentpcname.domain.name -MainDHCPServerName mainpcname.domain.name -ScopeId 192.168.1.0 -SharedSecret "Aa123456"
#>

function AutoInstallDHCPFailover {
    [CmdletBinding()]
    param (
        # Domain name of the domain controller.
        [Parameter(Mandatory = $true)]
        [string]
        $DomainName,

        # Ip addresses of the dns servers.
        [Parameter(Mandatory = $true)]
        [ipaddress[]]
        $DnsServers,

        # Ip addresses of router.
        [Parameter(Mandatory = $true)]
        [ipaddress]
        $Router,

        [Parameter(Mandatory = $true)]
        [string]
        $DnsName,

        [Parameter(Mandatory = $true)]
        [string]
        $MainDHCPServerName,

        [Parameter(Mandatory = $false)]
        [string]
        $ClusterName = $env:computername + "_Hot_standby",

        [Parameter(Mandatory = $true)]
        [ipaddress]
        $ScopeId,

        [Parameter(Mandatory = $true)]
        [string]
        $SharedSecret
    )
    
    begin {
        Write-Output("Turning firewall off...")
        netsh advfirewall set allprofiles state off
    }
    
    process {
        try {
            Install-WindowsFeature DHCP -IncludeManagementTools
            Set-DHCPServerV4OptionValue -dnsdomain $DomainName -dnsserver $DnsServers -router $Router
            Add-DHCPServerInDC -dnsname $DnsName
            Add-DhcpServerv4Failover -ComputerName $DnsName -PartnerServer $MainDHCPServerName -Name $ClusterName -ServerRole Standby -ReservePercent 10 -MaxClientLeadTime 1:00:00 -StateSwitchInterval 00:45:00 -ScopeId $ScopeId -SharedSecret $SharedSecret
            restart-service dhcpserver
        }

        catch {
            Write-Host "An error occurred (at " + $_.ScriptStackTrace + "):"
            Write-Host $_
        }
    }
    
    end {
        Write-Output("Turning firewall on...")
        netsh advfirewall set allprofiles state on
    }
}

function AutoInstallIIS {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        Write-Output("Turning firewall off...")
        netsh advfirewall set allprofiles state off
    }
    
    process {
        try {
            Install-WindowsFeature -Name FS-FileServer -IncludeAllSubFeature -IncludeManagementTools
            Install-Module -Name NTFSSecurity
            Install-WindowsFeature Web-Server -IncludeManagementTools
            add-WindowsFeature Web-Mgmt-Service
            Import-module servermanager
            Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WebManagement\Server -Name EnableRemoteManagement -Value 1
            Net Stop WMSVC
            Net Start WMSVC
            Set-Service WMSVC -StartupType Automatic
            IISRESET /restart
        }
        
        catch {
            Write-Host "An error occurred (at " + $_.ScriptStackTrace + "): "
            Write-Host $_
        }
    }
    
    end {
        Write-Output("Turning firewall on...")
        netsh advfirewall set allprofiles state on
    }
}

function CreateLocalUser {
    [CmdletBinding()]
    param (
        # Username of the user.
        [Parameter(Mandatory = $true)]
        [string]
        $ParameterName,

        # Password of the user.
        [Parameter(Mandatory = $true)]
        [string]
        $Password,

        # Group of the user.
        [Parameter(Mandatory = $true)]
        [ParameterType]
        $Group,

        # Description of the user.
        [Parameter(Mandatory = $false)]
        [string]
        $Description = ""
    )    
    process {
        New-LocalUser "$Username" -Password (convertto-securestring $Password -AsPlainText -Force) -FullName "$Username" -Description $Description
        Write-Verbose "$Username local user crated"
        Add-LocalGroupMember -Group $Group -Member "$Username"
        Write-Verbose "$Username added to the local administrator group"
    }    
}

function CreateDomainUser {
    [CmdletBinding()]
    param (
        # Username of the new user.
        [Parameter(Mandatory = $true)]
        [string]
        $Username,

        # Password of the new user.
        [Parameter(Mandatory = $true)]
        [string]
        $Password,

        # User Principal Name.
        [Parameter(Mandatory = $false)]
        [string]
        $UserPrincipalName = $Username + "@" + $env:USERDNSDOMAIN,

        # Full name of the new user.
        [Parameter(Mandatory = $false)]
        [string]
        $Name = $Username,

        # Does the new user have to change password on first logon ?
        [Parameter(Mandatory = $false)]
        [bool]
        $ChangePasswordAtLogon = $true,

        # Display name of the new user.
        [Parameter(Mandatory = $false)]
        [string]
        $DisplayName = $Username,

        # Department of the new user.
        [Parameter(Mandatory = $false)]
        [string]
        $Department = $env:USERDNSDOMAIN,

        # CN group where the new user will be placed.
        [Parameter(Mandatory = $false)]
        [string]
        $CN = "Users"
    )
    
    process {
        $domainName = ($env:USERDNSDOMAIN).split('.')
        New-ADUser -SamAccountName $Username -UserPrincipalName $UserPrincipalName -Name $Name -Enabled $True -ChangePasswordAtLogon $ChangePasswordAtLogon -DisplayName $DisplayName -Department $Department -Path "CN=$CN, DC=$($domainName[0]), DC=$($domainName[1])" -AccountPassword (convertto-securestring $Password -AsPlainText -Force)
    }
}
