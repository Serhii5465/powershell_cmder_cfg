$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SillyContinue'

function RestoreCygwin {
    $File_Setup = "${PSScriptRoot}\setup.exe"
    $File_Packages = "${PSScriptRoot}\list_packages.dat"
    $URI_Cygwin = "https://www.cygwin.com/setup-x86_64.exe"
    $Root_Install = "D:\system\applications\cygwin64"

    if (!(Test-Path -Path $File_Packages)) {
        Write-Error "Cygwin packages file not found"
    }

    try {
        Invoke-WebRequest -Uri $URI_Cygwin -OutFile $File_Setup -UseBasicParsing
        Write-Host "The Cygwin setup.exe has been successfully downloaded. Installation process started"
    }
    catch {
        Write-Error $PSItem.Exception.Message
    }

    $Packages = Get-Content -Path $File_Packages

    Start-Process -FilePath "setup-x86_64.exe" -ArgumentList "--quiet-mode --site https://sunsite.icm.edu.pl/pub/cygnus/cygwin/ -R $Root_Install --no-startmenu --no-desktop --arch x86_64 -P $Packages"
}

Export-ModuleMember -Function RestoreCygwin