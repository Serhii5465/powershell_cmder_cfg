Add-Type -AssemblyName System.IO.Compression.FileSystem

Set-Location $PSScriptRoot

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SillyContinue'

function IsValidDrive {
    param (
        [string]$Drive
    )
    
    if(Get-WmiObject -Class Win32_LogicalDisk | Where-Object -Property DeviceID -eq $Drive){
        Write-Host "The disk named $Drive exists. Initiating compression of free space"
    } else {
        Write-Error "$Drive does not exist"
    }
}

function ExtractToFile {
    param (
        [string]$Archive,
        [string]$File_SDelete
    )
    
    try {
        $Contents = [System.IO.Compression.ZipFile]::OpenRead("${PSScriptRoot}\${Archive}")

        if($Found_File = $Contents.Entries | Where-Object Name -eq $File_SDelete){
            [System.IO.Compression.ZipFileExtensions]::ExtractToFile($Found_File, "${PSScriptRoot}\${File_SDelete}")
            Write-Host "$File_SDelete located in ZIP"
        } else {
            Write-Error "File not found in ZIP: $File_SDelete"
        }
    }
    catch {
        Write-Error $PSItem.Exception.Message
    }
    finally {
        if($Contents){
            $Contents.Dispose()
        }
    } 
}

function ZeroSpace {
    param (
        [Parameter(Mandatory,HelpMessage="Enter drive letter with ':'. Example 'D:'")]
        [string]
        $Drive
    )

    IsValidDrive $Drive

    $URI_SDelete = "https://download.sysinternals.com/files/SDelete.zip"
    $File_SDelete = "sdelete64.exe"
    $File_Archive = "SDelete.zip"

    if(!(Test-Path -Path $File_SDelete)){
        try {
            Invoke-WebRequest -Uri $URI_SDelete -OutFile $File_Archive -UseBasicParsing
            Write-Host "Downloading the SDelete utility"
        }
        catch {
            Write-Error $PSItem.Exception.Message
        }

        ExtractToFile $File_Archive $File_SDelete
        
        if(Test-Path -Path $File_Archive){
            Remove-Item -Force $File_Archive
        }
    }

    $Proc = Start-Process -NoNewWindow -PassThru -FilePath ".\${File_SDelete}" -ArgumentList "-nobanner -Z $Drive"
    $Proc.WaitForExit();
}

Export-ModuleMember -Function ZeroSpace