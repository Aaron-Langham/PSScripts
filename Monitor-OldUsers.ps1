# Monitors Active directory Users that have not been logged into for a given amount of days.

$threashold = -180 # Negative Integer, the age threshold of accounts that any older will be disabled.

$age = (Get-Date).AddDays($threashold)

$DomainCheck = Get-CimInstance -ClassName Win32_OperatingSystem
if ($DomainCheck.ProductType -ne "2") { Write-Host "Not a domain controller. Soft exiting." ; exit 0 }

$blacklistU = @(
"Administrator"
)

$OldUsers = Get-ADuser -Filter * -properties Name, UserPrincipalName, SamAccountName, Enabled, WhenCreated, LastLogonDate, msDS-LastSuccessfulInteractiveLogonTime | Select-Object Name, UserPrincipalName, SamAccountName, Enabled, WhenCreated, LastLogonDate, msDS-LastSuccessfulInteractiveLogonTime | Where-Object { $_.LastLogonDate -lt $age } | Where-Object { $_.Enabled -eq $True}| Where-Object { $_.UserPrincipalName -ne $null} | Where-Object { $_.Name -notin $blacklistU} | Where-Object { $_.SamAccountName -notin $blacklistU} | Where-Object { $_.WhenCreated -lt ((Get-Date).AddDays(-14))}

if (!$OldUsers) {Write-Host "Healthy"; exit 0}
else {
    Write-Host "Not Healthy - User accounts found that have not logged on for 180 days:"
    if ($Host.Version.Major -gt 4){foreach ($message in $OldUsers){Write-Host $message}}
    elseif ($Host.Version.Major -lt 5){foreach ($message in $OldUsers){$message}}
    else {foreach ($message in $OldUsers){Write-Host $message}}
    exit 1
}
