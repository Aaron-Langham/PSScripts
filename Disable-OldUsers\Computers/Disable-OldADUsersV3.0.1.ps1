$date = Get-Date -Format yyyy-MM-dd
$age = (Get-Date).AddDays(-180)

$DomainCheck = Get-CimInstance -ClassName Win32_OperatingSystem
if ($DomainCheck.ProductType -ne "2") { Write-Host "Not a domain controller. Soft exiting." ; exit 0 }

$blacklistU = @(
"Administrator")

New-Item -ItemType Directory -Force -Path C:\DiscStuff\Logs

$OldUsers = Get-ADuser -Filter * -properties Name, UserPrincipalName, SamAccountName, Enabled, WhenCreated, LastLogonDate, msDS-LastSuccessfulInteractiveLogonTime | Select-Object Name, UserPrincipalName, SamAccountName, Enabled, WhenCreated, LastLogonDate, msDS-LastSuccessfulInteractiveLogonTime | Where-Object { $_.LastLogonDate -lt $age } | Where-Object { $_.Enabled -eq $True}| Where-Object { $_.UserPrincipalName -ne $null} | Where-Object { ($_.UserPrincipalName -split "@")[0] -notin $blacklistU} | Where-Object { $_.WhenCreated -lt ((Get-Date).AddDays(-14))}

foreach ($user in $OldUsers){Set-ADUser -Identity $user.SamAccountName -Enabled $false}

$OldUsers | ConvertTo-html -Property Name, UserPrincipalName, SamAccountName, WhenCreated, LastLogonDate | Out-File C:\DiscStuff\Logs\$date-OldUsers.html

if (!$OldUsers) {Write-Host "No Users Accounts Disabled"; exit 0}
else {Write-Host "User accounts found that have not logged on for 180 days have been disabled. Pleased see log on Device to see details: C:\DiscStuff\Logs"
    if ($Host.Version.Major -gt 4){foreach ($message in $OldUsers){Write-Host $message}}
    elseif ($Host.Version.Major -lt 5){foreach ($message in $OldUsers){$message}}
    else {foreach ($message in $OldUsers){Write-Host $message}}
    exit 1
}
