# Monitors whether the local Administrator account's password has changed 

$version = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentVersion
if($Version -lt "6.3") {write-host "Unsupported OS. Only Server 2012R2 or 8.1 and up are supported."; exit 0}

$LastDay = (Get-Date).addhours(-24)
$AdminGroup = Get-LocalGroupMember -SID "S-1-5-32-544"

$ChangedAdmins = foreach($Admin in $AdminGroup){get-localuser -ErrorAction SilentlyContinue -sid $admin.sid | Where-Object {$_.PasswordLastSet -gt $LastDay}}

if  (!$ChangedAdmins){write-host "Healthy"}
else {write-host "Unhealthy. Please check diagnostics"; write-host ($ChangedAdmins | fl *); exit 1}
