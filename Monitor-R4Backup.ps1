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


if (($filteredFullBackupLog -ne $null) -and ($filteredDbBackupLog -ne $null)){Write-Host "Both Backups have Run"; exit 0}
elseif (($filteredFullBackupLog -eq $null) -and ($filteredDbBackupLog -ne $null)){Write-Host "Full Backup has NOT Run"; exit 1}
elseif (($filteredFullBackupLog -ne $null) -and ($filteredDbBackupLog -eq $null)){Write-Host "Database Backup has NOT Run"; exit 1}
elseif (($filteredFullBackupLog -eq $null) -and ($filteredDbBackupLog -eq $null)){Write-Host "Both Backups have NOT Run"; exit 1}
else {Write-Host "Error"; exit 1}
