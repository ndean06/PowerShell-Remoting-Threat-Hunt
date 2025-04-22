<#
.SYNOPSIS
  Remotely calculates SHA256 hashes of specified files on multiple systems.

.DESCRIPTION
  Uses PowerShell Remoting to connect to each host and run Get-FileHash on one or more file paths.
  Helpful for verifying malware IOCs like broker.exe or proxy.exe.

.PARAMETER ComputerName
  List of remote systems to check.

.PARAMETER Credential
  Credential object used for authentication.

.PARAMETER FilePaths
  One or more full file paths to check (e.g., C:\Windows\broker.exe)

.EXAMPLE
  .\hash-check.ps1 -ComputerName alpha-svr1, alpha-svr2 -Credential (Get-Credential) -FilePaths "C:\Windows\broker.exe"
#>

param (
    [Parameter(Mandatory)]
    [string[]]$ComputerName,

    [Parameter(Mandatory)]
    [pscredential]$Credential,

    [Parameter(Mandatory)]
    [string[]]$FilePaths
)

foreach ($file in $FilePaths) {
    Write-Host "`nHashing: $file" -ForegroundColor Cyan

    Invoke-Command -ComputerName $ComputerName -Credential $Credential -Authentication Basic -ScriptBlock {
        param ($targetFile)
        if (Test-Path $targetFile) {
            Get-FileHash -Path $targetFile -Algorithm SHA256
        } else {
            Write-Warning "File not found: $targetFile"
        }
    } -ArgumentList $file | Format-Table PSComputerName, Algorithm, Hash, Path -AutoSize
}
