$ScheduledTasks = Get-ScheduledTask -TaskName "ShadowCopy*"
$DefaultTasks = Get-ScheduledTask -TaskName "ShadowCopyVolume{*}"
$CustomTasks = Get-ScheduledTask -TaskName "ShadowCopy * drive"

$VSS = [PSCustomObject]@{
    enabled = $false
    type = $null
}
#No Tasks
if ($ScheduledTasks -eq $null)
    {Write-Host "No VSS Tasks"}
#Default Tasks
elseif ($DefaultTasks.State -ne "Disabled")
    {Write-Host "Default VSS Tasks Enabled"; $VSS.enabled = $true; $VSS.type = "Default"}
#Default Tasks Disabled and No Custom Tasks
if (($DefaultTasks.State -eq "Disabled") -and ($CustomTasks -eq $null))
    {Write-Host "Default VSS Tasks Disabled and NO Custom VSS Tasks"; $VSS.enabled = $false; $VSS.type = "Default"}
#Default Tasks Disabled and Custom Tasks Enabled
if ((($DefaultTasks.State -eq "Disabled") -or ($DefaultTasks -eq $null)) -and ($CustomTasks -ne $null))
    {Write-Host "Default VSS Tasks Disabled and Custom VSS Tasks Enabled"; $VSS.enabled = $true; $VSS.type = "Custom"}

if ($Host.Version.Major -gt 4){Write-Host $VSS}
elseif ($Host.Version.Major -lt 5){$VSS}

Ninja-Property-Set vssenabled $VSS.enabled
Ninja-Property-Set vsstype $VSS.type

if ($VSS.enabled -eq $false){exit 1}
elseif ($VSS.type -eq "Default"){exit 2}
else{exit 0}
