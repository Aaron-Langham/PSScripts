$UserFolder = "C:\Users"
$OutlookFolder = "AppData\Local\Microsoft\Outlook"

class OST {
    [string]$name
    [float]$size
}

Get-ChildItem -Path $UserFolder | ForEach-Object {
    $User = $_
    $Folder = "$User\$OutlookFolder"
    if ($(Test-Path -Path $Folder)){
        $FoundFiles = Get-ChildItem $Folder -Filter *.ost | Where-Object {$_.Length / 1GB -gt 1}
        $FoundFiles | Select-Object FullName, Length | ForEach-Object {
            $Name = $_.FullName
            $Size = [Math]::Round(($_.Length / 1GB), 2)
            $ost = [OST]::new()
            $ost.name = $Name
            $ost.size = $Size
        }
    }
}

$ost
