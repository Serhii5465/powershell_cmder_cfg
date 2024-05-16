Add-Type -AssemblyName System.IO.Compression.FileSystem

Set-Location $PSScriptRoot

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SillyContinue'

Import-Module -Name .\private\UnpackSDelete.ps1 -Force
Import-Module -Name .\private\Wiping.ps1 -Force

function ZeroSpace {
    param (
        [Parameter(Mandatory,HelpMessage="Enter drive letters with ':' separated by commas. Example 'D:'")]
        [ValidateScript({
            foreach ($item in $_) {
                if (-not (Get-WmiObject -Class Win32_LogicalDisk | Where-Object -Property DeviceID -eq $item)){
                    throw "${item} does not exist"
                }
            }
            $true
        })]
        [string[]]$Drives
    )

    $URI_SDelete = "https://download.sysinternals.com/files/SDelete.zip"
    $Name_Archive_SDelete = "SDelete.zip"
    $Name_File_SDelete = "sdelete64.exe" 
    
    $Path_Archive_SDelete = Join-Path $PSScriptRoot $Name_Archive_SDelete
    $Path_File_SDelete = Join-Path $PSScriptRoot $Name_File_SDelete

    UnpackSDelete $URI_SDelete $Name_File_SDelete $Path_Archive_SDelete $Path_File_SDelete

    foreach ($item in $Drives){
        Wiping $item $Path_File_SDelete
    }
}