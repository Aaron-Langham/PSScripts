function Write-Diag {
    foreach ($Message in $Messages) { $Message }
}

$FirewallState = @()

$FirewallProfiles = Get-NetFirewallProfile | Where-Object {$_.Enabled -eq $false}

If($FirewallProfiles){$FirewallState += "$($FirewallProfiles.name) Profile is disabled"}

$FirewallAllowed = Get-NetFirewallProfile | Where-Object {$_.DefaultInboundAction -eq "Allow"}

If($FirewallAllowed){$FirewallState += "$($FirewallAllowed.name) Profile is set to $($FirewallAllowed.DefaultInboundAction) inbound traffic"}

if(!$FirewallState){Write-Host "healthy"} 
else {
    Write-Host $FirewallState 
    Write-Diag @($FirewallProfiles,$FirewallAllowed)
    exit 1
}
