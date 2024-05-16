function Wiping {
    param(
        [string]$Drive,
        [string]$File_SDelete
    )    
    (Start-Process -NoNewWindow -PassThru -FilePath $File_SDelete -ArgumentList "-nobanner -Z $Drive").WaitForExit();
}