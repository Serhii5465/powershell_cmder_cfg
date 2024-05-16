$ErrorActionPreference = 'Stop'

function CompressVDI {
    param (
        [Parameter(Mandatory, HelpMessage="Enter disk locations separated by commas")]
        [ValidateScript({
            foreach ($item in $_) {
                if (-not (Test-Path $item)) {
                    throw "Path ${item} does not exist"
                }

                $Extn = [IO.Path]::GetExtension($item)
                if (-not ($Extn -eq ".vdi")) {
                    throw "${item} is not a VDI file"
                }
            }
            $true
        })]
        [string[]]$VDI_Files
    )
    
    $VBox_Path = "C:\Program Files\Oracle\VirtualBox"

    if(!(Test-Path -Path $VBox_Path)){
        Write-Error "VirtualBox is not installed"
    }

    foreach ($item in $VDI_Files) {
        Write-Host "Processing VDI: ${item}"
        (Start-Process -NoNewWindow -PassThru -FilePath "${VBox_Path}\VBoxManage.exe" -ArgumentList "modifymedium --compact $item").WaitForExit();
        Write-Host "`n"
    }
}