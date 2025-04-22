<#
.SYNOPSIS
  Checks for recently installed services (Event ID 7045) across remote Windows systems.

.DESCRIPTION
  Uses PowerShell Remoting to query the System Event Log on specified remote hosts.
  Helps identify potentially malicious or unexpected service installations (e.g. persistence mechanisms).

.PARAMETER ComputerName
  Array of target hostnames.

.PARAMETER Credential
  Admin credential for remoting (Get-Credential object).

.EXAMPLE
  .\service-check.ps1 -ComputerName alpha-svr1, alpha-svr2 -Credential (Get-Credential)
#>

param (
    [Parameter(Mandatory)]
    [string[]]$ComputerName,

    [Parameter(Mandatory)]
    [pscredential]$Credential
)

Invoke-Command -ComputerName $ComputerName -Credential $Credential -Authentication Basic -ScriptBlock {
    Get-WinEvent -FilterHashtable @{LogName = 'System'; ID = 7045} -MaxEvents 3 |
        Select-Object TimeCreated, Message
} | Format-Table PSComputerName, TimeCreated, Message -AutoSize
