$age = (Get-Date).AddDays(-180)

$DomainCheck = Get-CimInstance -ClassName Win32_OperatingSystem
if ($DomainCheck.ProductType -ne "2") { Write-Host "Not a domain controller. Soft exiting." ; exit 0 }

$blacklistU = @(
"Administrator"
"Disc"
"SQL"
"DFWTechSupport"
"SOE"
"soe")

$OldUsers = Get-ADuser -Filter * -properties UserPrincipalName, Enabled, WhenCreated, LastLogonDate | Select-Object UserPrincipalName, Enabled, WhenCreated, LastLogonDate | Where-Object { $_.LastLogonDate -lt $age } | Where-Object { $_.Enabled -eq $True}| Where-Object { $_.UserPrincipalName -ne $null} | Where-Object { ($_.UserPrincipalName -split "@")[0] -notin $blacklistU} | Where-Object { $_.WhenCreated -lt ((Get-Date).AddDays(-14))}

if (!$OldUsers) {Write-Host "Healthy"; exit 0}
else {
    Write-Host "Not Healthy - User accounts found that have not logged on for 180 days:"
    if ($Host.Version.Major -gt 4){foreach ($message in $OldUsers){Write-Host $message}}
    elseif ($Host.Version.Major -lt 5){foreach ($message in $OldUsers){$message}}
    else {foreach ($message in $OldUsers){Write-Host $message}}
    exit 1
}
