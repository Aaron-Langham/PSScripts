# Monitors Active directory Computers that have not been logged into for a given amount of days.

$threashold = -180 # Negative Integer, the age threshold of accounts that any older will be disabled.

$age = (Get-Date).AddDays($threashold)

$DomainCheck = Get-CimInstance -ClassName Win32_OperatingSystem
if ($DomainCheck.ProductType -ne "2") { Write-Host "Not a domain controller. Soft exiting." ; exit 0 }

$OldComputers = Get-ADComputer -Filter * -properties Name,DNSHostName,SamAccountName,Enabled,WhenCreated,LastLogonDate,operatingsystem,isCriticalSystemObject | Select-Object Name,DNSHostName,SamAccountName,Enabled,WhenCreated,LastLogonDate,operatingsystem,isCriticalSystemObject | Where-Object {$_.LastLogonDate -lt $age} | Where-Object { $_.Enabled -eq $True} | Where-Object {$_.operatingsystem -notlike "*server*"} | Where-Object {$_.isCriticalSystemObject -eq $false} | Where-Object { $_.WhenCreated -lt ((Get-Date).AddDays(-14))}

if (!$OldComputers) {Write-Host "Healthy"; exit 0}
else {
    Write-Host "Not Healthy - Computer accounts found that have not logged on for 180 days"
    if ($Host.Version.Major -gt 4){foreach ($message in $OldComputers){Write-Host $message}}
    elseif ($Host.Version.Major -lt 5){foreach ($message in $OldComputers){$message}}
    else {foreach ($message in $OldComputers){Write-Host $message}}
    exit 1
}
