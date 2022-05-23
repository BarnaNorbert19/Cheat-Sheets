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
