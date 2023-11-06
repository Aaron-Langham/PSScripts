$Recycler = Get-ADOptionalFeature -Filter 'name -like "Recycle Bin Feature"'

if(!$Recycler.EnabledScopes){Write-Host "Active Directory Recycle Bin is not enabled"; exit 1}
else{Write-Host "Healthy"}
