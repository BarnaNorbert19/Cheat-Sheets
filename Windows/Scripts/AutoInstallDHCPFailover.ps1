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
