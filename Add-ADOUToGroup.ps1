# Takes all the users from an OU and adds them to a group.

$OUName = "" # Name of the OU
$GroupName = "" # Name of the Group

$OU = Get-ADOrganizationalUnit -Filter "Name -like '$OUName'" -Properties DistinguishedName
$OUPath = $OU.DistinguishedName

$Users = Get-ADUser -Filter * -SearchBase $OUPath | Select-Object

Add-ADGroupMember -Identity $GroupName -Members $Users
