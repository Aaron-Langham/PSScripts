$OU = "OU=$OUName,OU=$OUGroup,OU=MyBusiness,DC=$Domain,DC=local" # OU Path
$logPath = "C:\Logs" # Log output Path
$date = Get-Date -Format yyyy-MM-dd

$groups = Get-ADGroup -Filter * -SearchBase $OU

$groupsMembers = ForEach ($group in $groups){
    #$group.Name
    $members = Get-ADGroupMember -Identity $group
    $groupMembers = [PSCustomObject]@{
        GroupName = $group.Name
        Members = $members.Name
    }
    $groupMembers
}
$groupsMembers = $groupsMembers | Sort-Object -Property GroupName


$groupsMembers1 = ForEach ($group in $groupsMembers){
    $group1 = [PSCustomObject]@{
        GroupName = $group.GroupName
        Members = $null
    }
    $group1
    $group.Members = $group.Members | Sort-Object
    ForEach ($member in $group.Members){
        $group2 = [PSCustomObject]@{
            GroupName = $null
            Members = $member
        }
        $group2
    }
}

$groupsMembers1 | ConvertTo-Html -Property GroupName, Members | Out-File "$logPath\$date-GroupMembers.html"
