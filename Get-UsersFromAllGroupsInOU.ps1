# This script is run against an OU, you'll have to edit the first variable in the script ($OU) to the OU path that you need. 
# For example: $OU = "OU=Folder Permissions,OU=Security Groups,OU=MyBusiness,DC=costno,DC=local"
# That path can be found in the Properties > Attribute Editor > distinguishedName of the OU in question:

$OU = "" # OU Path
$logPath = "C:\Logs" # Log output Path
$date = Get-Date -Format yyyy-MM-dd
$name = (((($OU -split "=")[1] -split ",")[0]) -replace '\s','') -replace '\W',''

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

$groupsMembers1 | ConvertTo-Html -Property GroupName, Members | Out-File "$logPath\$date-$name-GroupMembers.html"
