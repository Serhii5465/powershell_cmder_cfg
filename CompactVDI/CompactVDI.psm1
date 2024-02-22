$ErrorActionPreference = 'Stop'

function CompactVDI {
    param(
        [Parameter(Mandatory, HelpMessage="Enter the path to the virtual disk image")]
        [string]
        $VDI_file
    )

    $VBox_Path = "C:\Program Files\Oracle\VirtualBox"

    if(!(Test-Path -Path $VDI_file)){
        Write-Error "${VDI_file} do not exist"
    }

    if(!(Test-Path -Path $VBox_Path)){
        Write-Error "VirtualBox is not installed"
    }
    
    $Proc = Start-Process -NoNewWindow -PassThru -FilePath "${VBox_Path}\VBoxManage.exe" -ArgumentList "modifymedium --compact $VDI_file"
    $Proc.WaitForExit();
}

Export-ModuleMember -Function CompactVDI