Function Get-PrivilegedGroupChanges {
    Param(
        $Server = "localhost",
        $Hour = 24
    )
    
    $ProtectedGroups = Get-ADGroup -Filter 'AdminCount -eq 1' -Server $Server
    $Members = @()
    
    ForEach ($Group in $ProtectedGroups) {
        $Members += Get-ADReplicationAttributeMetadata -Server $Server `
        -Object $Group.DistinguishedName -ShowAllLinkedValues |
        Where-Object {$_.IsLinkValue} |
        Select-Object @{name='GroupDN';expression={$Group.DistinguishedName}}, `
        @{name='GroupName';expression={$Group.Name}}, *
    }
    $Members |
    Where-Object {$_.LastOriginatingChangeTime -gt (Get-Date).AddHours(-1 * $Hour)}
}

$ListOfChanges = Get-PrivilegedGroupChanges

foreach($Change in $ListOfChanges){
    if($Change.LastOriginatingDeleteTime -gt "1-1-1601 01:00:00"){ $ChangeType = "removed"  } 
    else { $ChangeType = "added"}
    write-host "$($Change.groupname) has been edited. $($Change.AttributeValue) has been $ChangeType"
}

if($ListOfChanges -eq $Null){write-host "GroupChanges=Healthy"} 
elseif($ListOfChanges.count -gt 1){
    write-host "GroupChanges=Multiple groups have been changed. Please check diagnostic data"
    exit 1
}
else{
    if($listofchanges.LastOriginatingDeleteTime -gt "1-1-1601 01:00:00"){ $ChangeType = "removed"  } 
    else { $ChangeType = "added"}
    write-host "GroupChanges=$($ListOfChanges.groupname) has been edited. $($listofchanges.AttributeValue) has been $ChangeType"
    exit 1
}
