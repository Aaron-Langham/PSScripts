$driver = Get-WindowsDriver -Online -all | Where-Object {$_.ProviderName -eq "SafeNet, Inc."}

if ($driver -eq $null){Write-Host "Licence Key is Missing"; exit 1}
else {Write-Host "Licence Key is Present"; exit 0}
