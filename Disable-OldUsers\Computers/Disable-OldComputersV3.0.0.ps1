$date = Get-Date -Format yyyy-MM-dd
$age = (Get-Date).AddDays(-180)

$DomainCheck = Get-CimInstance -ClassName Win32_OperatingSystem
if ($DomainCheck.ProductType -ne "2") { Write-Host "Not a domain controller. Soft exiting." ; exit 0 }

New-Item -ItemType Directory -Force -Path C:\DiscStuff\Logs

$OldComputers = Get-ADComputer -Filter * -properties Name,DNSHostName,SamAccountName,Enabled,WhenCreated,LastLogonDate | Select-Object Name,DNSHostName,SamAccountName,Enabled,WhenCreated,LastLogonDate | Where-Object {$_.LastLogonDate -lt $age} | Where-Object { $_.Enabled -eq $True} | Where-Object {$_.operatingsystem -notlike "*server*"} | Where-Object { $_.WhenCreated -lt ((Get-Date).AddDays(-14))}

foreach ($computer in $OldComputers){Set-ADComputer -Identity $computer.SamAccountName -Enabled $false}

$OldComputers | ConvertTo-html -Property Name, DNSHostName, SamAccountName, WhenCreated, LastLogonDate | Out-File C:\DiscStuff\Logs\$date-OldComputers.html

if (!$OldComputers) {Write-Host "No Computer Accounts Disabled"; exit 0}
else {Write-Host "User Computer found that have not logged on for 180 days have been disabled. Pleased see log on Device to see details: C:\DiscStuff\Logs"
    if ($Host.Version.Major -gt 4){foreach ($message in $OldComputers){Write-Host $message}}
    elseif ($Host.Version.Major -lt 5){foreach ($message in $OldComputers){$message}}
    else {foreach ($message in $OldComputers){Write-Host $message}}
    exit 1
}
