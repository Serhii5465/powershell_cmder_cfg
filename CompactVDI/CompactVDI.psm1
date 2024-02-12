$ErrorActionPreference = 'Stop'

function CompactVDI {
    param(
        [Parameter(Mandatory, HelpMessage="Enter one or more paths to virtual disk images separated by commas")]
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
    
    $Proc = Start-Process -PassThru -FilePath "${VBox_Path}\VBoxManage.exe" -ArgumentList "modifymedium --compact $VDI_file"
    $handle = $proc.Handle
    $Proc.WaitForExit();
}

Export-ModuleMember -Function CompactVDI