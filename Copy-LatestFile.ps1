# Looks at the latest file in a given directory and then copies it to a second given directory. 

$targetPath = "" # Source directory
$outputPath = "" # Output directory

Set-Location $targetPath
$latestFile = (Get-ChildItem -Path $targetPath -Attributes !Directory | Sort-Object -Descending -Property LastWriteTime | Select-Object -First 1)

Copy-Item -Path $latestFile -Destination $outputPath
