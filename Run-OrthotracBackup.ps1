function Write-Diag ($messages) {
    foreach ($Message in $Messages) { $Message }
}
Function Write-Alert ($message) 
{
    write-host "Alert=$message"
}

Function Get-OMSDir 
{
    $Disks = (get-volume).driveletter | Where-Object {$_ -ne $null}

    $OMSDisk = ForEach ($Disk in $Disks)
    {
        $Drive = "$Disk"+":\"
        $Search = Get-ChildItem "$Drive" | Where-Object {$_.PSIsContainer -eq $true -and $_.Name -match "Orthotrac"}
        if ($Search -ne $null){echo $Disk}
    }
    
    $OMSDir = "$OMSDisk"+":\Orthotrac\OMS"
    echo $OMSDir
}

Function Execute-OrthoBackup
{
    $OMSDir = Get-OMSDir
    cd $OMSDir
    .\orthobac.exe
}

Try
{
    Execute-OrthoBackup
    Write-Alert "Orthotrac Backup Ran Correctly"
    Write-Diag @("Orthotrac Backup Ran Correctly" | out-string)
    exit 0
}
Catch
{
    Write-Alert "Orthotrac Backup did NOT run Correctly"
    Write-Diag @("Orthotrac Backup did NOT run Correctly" | out-string)
    exit 1
}
exit 1
