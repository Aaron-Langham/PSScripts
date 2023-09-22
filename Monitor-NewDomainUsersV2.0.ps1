$When = ((Get-Date).AddDays(-1)).Date
$GetUsers = Get-ADUser -Filter { whenCreated -ge $When } -Properties whenCreated

$UserChanges = foreach ($User in $GetUsers) {
    [PSCustomObject]@{
        Name      = $user.name
        CreatedOn = $user.whencreated
        UPN       = $user.userprincipalname
    }
}

if (!$GetUsers) {Write-Host "Healthy - No new users found"}
else {
    Write-Host "New Users Found"
    if (($UserChanges | Measure-Object).Count -ne 1){foreach ($User in $UserChanges) { $User }}
    else{$UserChanges[0]}
    exit 1
}
