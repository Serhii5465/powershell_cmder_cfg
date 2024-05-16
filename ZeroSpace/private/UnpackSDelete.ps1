function UnpackSDelete {
    param (
        [string]$URI_SDelete,
        [string]$Name_File_SDelete,
        [string]$Path_Archive_SDelete,
        [string]$Path_File_SDelete
    )
    
    if(!(Test-Path -Path $Name_File_SDelete)){
        try {
            Invoke-WebRequest -Uri $URI_SDelete -OutFile $Path_Archive_SDelete -UseBasicParsing
            Write-Host "Downloading the SDelete utility"
        }
        catch {
            Write-Error $PSItem.Exception.Message
        }

        try {
            $Contents = [System.IO.Compression.ZipFile]::OpenRead("${Path_Archive_SDelete}")
    
            if($Found_File = $Contents.Entries | Where-Object Name -eq $Name_File_SDelete){
                [System.IO.Compression.ZipFileExtensions]::ExtractToFile($Found_File, "${Path_File_SDelete}")
                Write-Host "$Name_File_SDelete located in ZIP"
            } else {
                Write-Error "File not found in ZIP: $Name_File_SDelete"
            }
        }
        catch {
            Write-Error $PSItem.Exception.Message
        }
        finally {
            if($Contents){
                $Contents.Dispose()
                Remove-Item -Force $Path_Archive_SDelete
            }
        }
    }
}