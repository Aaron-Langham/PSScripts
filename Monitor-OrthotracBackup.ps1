$oldAge = -1
$oldDate = (Get-Date).AddDays($oldAge)

Function Get-BackupDir 
{
    $Disks = (get-volume).driveletter | Where-Object {$_ -ne $null}

    $BackupDisk = ForEach ($Disk in $Disks)
    {
        $Drive = "$Disk"+":\"
        $Search = Get-ChildItem "$Drive" | Where-Object {$_.PSIsContainer -eq $true -and $_.Name -match "Orthotrac"}
        if ($Search -ne $null){echo $Disk}
    }
    
    $BackupDir = "$BackupDisk"+":\Orthotrac\OMS\Backup\Most_Recent"
    echo $BackupDir
}

Function Get-BackupDate
{
    $BackupDir = Get-BackupDir
    
    $Files = ForEach ($File in (Get-ChildItem -Path $BackupDir)){echo $File}

    $EarliestFile = $Files | Sort-Object LastWriteTime | Select-Object -First 1

    echo $EarliestFile.LastWriteTime
}

$BackupDate = Get-BackupDate

if ($BackupDate -lt $oldDate){echo "Backup not ran today"}
else {echo "backup ran today"}
