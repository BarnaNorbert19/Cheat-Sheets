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
