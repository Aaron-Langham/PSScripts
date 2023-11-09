# Disables Active directory Computers that have not been logged into for a given amount of days and saves a report to a given file path.

$threashold = -180 # Negative Integer, the age threshold of accounts that any older will be disabled.
$logPath = "C:\Logs" # String, the file path for the log to be saved to. If it does not exist it will be created.

$date = Get-Date -Format yyyy-MM-dd
$age = (Get-Date).AddDays($threashold)

$DomainCheck = Get-CimInstance -ClassName Win32_OperatingSystem
if ($DomainCheck.ProductType -ne "2") { Write-Host "Not a domain controller. Soft exiting." ; exit 0 }

New-Item -ItemType Directory -Force -Path $logPath

$OldComputers = Get-ADComputer -Filter * -properties Name,DNSHostName,SamAccountName,Enabled,WhenCreated,LastLogonDate,operatingsystem,isCriticalSystemObject | Select-Object Name,DNSHostName,SamAccountName,Enabled,WhenCreated,LastLogonDate,operatingsystem,isCriticalSystemObject | Where-Object {$_.LastLogonDate -lt $age} | Where-Object { $_.Enabled -eq $True} | Where-Object {$_.operatingsystem -notlike "*server*"} | Where-Object {$_.isCriticalSystemObject -eq $false} | Where-Object { $_.WhenCreated -lt ((Get-Date).AddDays(-14))}

foreach ($computer in $OldComputers){Set-ADComputer -Identity $computer.SamAccountName -Enabled $false}

$OldComputers | ConvertTo-html -Property Name, DNSHostName, SamAccountName, WhenCreated, LastLogonDate | Out-File $logPath\$date-OldComputers.html

if (!$OldComputers) {Write-Host "No Computer Accounts Disabled"; exit 0}
else {Write-Host "User Computer found that have not logged on for 180 days have been disabled. Pleased see log on Device to see details: $logPath"
    if ($Host.Version.Major -gt 4){foreach ($message in $OldComputers){Write-Host $message}}
    elseif ($Host.Version.Major -lt 5){foreach ($message in $OldComputers){$message}}
    else {foreach ($message in $OldComputers){Write-Host $message}}
    exit 1
}
