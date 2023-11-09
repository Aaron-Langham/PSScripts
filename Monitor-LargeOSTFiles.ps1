# Monitors if any user's OST file is over a given size, default 45GB

param([double]$MinSize = 45)

$UserFolder = "C:\Users"
$OutlookFolder = "AppData\Local\Microsoft\Outlook"

Get-ChildItem -Path $UserFolder | ForEach-Object {
    $User = $_
    $Folder = "$User\$OutlookFolder"
    if ($(Test-Path -Path $Folder)){
        $FoundFiles = Get-ChildItem $Folder -Filter *.ost | Where-Object {$_.Length / ($MinSize * 1GB) -gt 1}
        $FoundFiles | Select-Object FullName, Length | ForEach-Object {
            $Name = $_.FullName
            $Size = [Math]::Round(($_.Length / 1GB), 2)
            Write-Host "$Name $Size GB"
        }
        if ($FoundFiles){$script:Found = $true}
    }
}

if ($script:Found) {exit 1}
else {exit 0}
