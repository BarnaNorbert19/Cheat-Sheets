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
