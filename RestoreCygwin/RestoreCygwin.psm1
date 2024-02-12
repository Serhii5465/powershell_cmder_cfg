Set-Location $PSScriptRoot

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SillyContinue'

function RestoreCygwin {
    $File_Setup = "setup.exe"
    $File_Packages = "list_packages.dat"
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

    $Proc = Start-Process -PassThru -FilePath $File_Setup -ArgumentList "--quiet-mode --site https://sunsite.icm.edu.pl/pub/cygnus/cygwin/ -R $Root_Install --no-startmenu --no-desktop --arch x86_64 -P $Packages"
    $handle = $proc.Handle
    $Proc.WaitForExit();

    if($Proc.ExitCode -eq 0){
        Write-Host "Removing temporary files"

        Remove-Item -Recurse -Force 'https*'
        Remove-Item -Force $File_Setup

        Write-Host "Succes.Exit with status code $($Proc.ExitCode)"
    } else {
        Write-Warning "Exit with status code $($Proc.ExitCode)"
    }
}

Export-ModuleMember -Function RestoreCygwin