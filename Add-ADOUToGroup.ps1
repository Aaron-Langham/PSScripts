$OUName = "SBSUsers"
$GroupName = "Disabled USB Access"

$OU = Get-ADOrganizationalUnit -Filter "Name -like '$OUName'" -Properties DistinguishedName
$OUPath = $OU.DistinguishedName

$Users = Get-ADUser -Filter * -SearchBase $OUPath | Select-Object

Add-ADGroupMember -Identity $GroupName -Members $Users