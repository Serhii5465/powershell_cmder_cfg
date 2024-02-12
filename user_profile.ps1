cd $env:userprofile

function Global:prompt{
    $curdir = $ExecutionContext.SessionState.Path.CurrentLocation.Path.Split("\")[-1]

    if($curdir.Length -eq 0) {
        $curdir = $ExecutionContext.SessionState.Drive.Current.Name+":\"
    }
    
    Write-Host "" 
    Write-Host ("PS " + $env:USERNAME + ":") -ForegroundColor Green -NoNewline
    Write-Host ("[" + $curdir + "]") -ForegroundColor DarkYellow
    return "-> "
}

$Env:PSModulePath = $Env:PSModulePath+";D:\system\applications\cmder\config\PowerShell_Modules"