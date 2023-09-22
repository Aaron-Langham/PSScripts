$ScheduledTasks = Get-ScheduledTask -TaskName "ShadowCopy * drive"

if ($ScheduledTasks -eq $null){
    Write-Host "No custom VSS Tasks"
    exit 1}
else{exit 0}
