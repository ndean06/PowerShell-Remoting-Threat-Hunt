<#
.SYNOPSIS
  Lists all members of the local Administrators group across remote systems.

.DESCRIPTION
  Uses PowerShell Remoting to find accounts that have local administrator privileges.
  Helps detect rogue or backdoor admin accounts (e.g., misspelled 'Adninistrator').

.PARAMETER ComputerName
  One or more remote hostnames.

.PARAMETER Credential
  Admin credentials used to authenticate for remoting.

.EXAMPLE
  .\admin-account-check.ps1 -ComputerName alpha-svr1, alpha-svr2 -Credential (Get-Credential)
#>

param (
    [Parameter(Mandatory)]
    [string[]]$ComputerName,

    [Parameter(Mandatory)]
    [pscredential]$Credential
)

Invoke-Command -ComputerName $ComputerName -Credential $Credential -Authentication Basic -ScriptBlock {
    Get-LocalGroupMember -Group "Administrators" |
        Select-Object Name, SID, PrincipalSource, ObjectClass
} | Format-Table PSComputerName, Name, SID, PrincipalSource, ObjectClass -AutoSize
