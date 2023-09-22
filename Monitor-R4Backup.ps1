try{
    $fullBackupLog = Get-EventLog -LogName Application -Source MSSQLSERVER -Message "*FullBackup*" -After (get-date).AddDays(-1)
    $filteredFullBackupLog = ForEach ($event in $fullBackupLog){if ($event.EventID -eq 18264){$event}}
}
catch{$filteredFullBackupLog = $null}

try {
    $dbBackupLog = Get-EventLog -LogName Application -Source MSSQLSERVER -Message "*DBBackup*" -After (get-date).AddHours(-18)
    $filteredDbBackupLog = ForEach ($event in $dbBackupLog){if ($event.EventID -eq 18264){$event}}
}
catch {$filteredDbBackupLog = $null}


if (($filteredFullBackupLog -eq $null) -or ($filteredDbBackupLog -eq $null)){exit 0}
else {exit 1}
