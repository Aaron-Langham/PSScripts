# Removes McAfee Apps

$McAfeeApps = Get-AppxPackage -Name "*McAfee*" -AllUsers | Select-Object *
foreach ($app in $McAfeeApps){Remove-AppxPackage -Package $app.PackageFullName -AllUsers}
