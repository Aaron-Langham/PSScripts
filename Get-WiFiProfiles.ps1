$wifi = $(netsh.exe wlan show profiles)

if ($wifi -match "There is no wireless interface on the system."){
    Write-Output $wifi
    exit 
}

$SSIDs = ($wifi | Select-string -pattern "\w*All User Profile.*: (.*)" -allmatches).Matches | ForEach-Object {$_.Groups[1].Value}

$SSIDsPassphrases = 
foreach ($SSID in $SSIDs){
    try {
        $passphrase = ($(netsh.exe wlan show profiles name="$SSID" key=clear) |
            Select-String -Pattern ".*Key Content.*:(.*)" -AllMatches).Matches |
                ForEach-Object {$_.Groups[1].Value}
    }
    catch{
        $passphrase = "N/A"
    }
    [PSCustomObject]@{
        SSID = $SSID
        Passphrase = $passphrase
    }
}

Write-Output "The WiFi profiles on this System are:" $SSIDsPassphrases