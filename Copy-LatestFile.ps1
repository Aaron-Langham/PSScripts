$targetPath = ""
$outputPath = ""

Set-Location $targetPath
$latestFile = (Get-ChildItem -Path $targetPath -Attributes !Directory | Sort-Object -Descending -Property LastWriteTime | Select-Object -First 1)

Copy-Item -Path $latestFile -Destination $outputPath
