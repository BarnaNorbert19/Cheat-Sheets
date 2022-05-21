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
