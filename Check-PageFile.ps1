# Checks if the page file is at 90% capacity

$AutoManaged = (Get-CimInstance Win32_ComputerSystem).AutomaticManagedPagefile
if ($AutoManaged -eq $false){Write-Host "Page file is not Automatically managed by Windows"; exit 0}

$page = Get-CimInstance Win32_PageFileUsage -Property *

$threshold = ($page.AllocatedBaseSize * (9/10))
if ($page.CurrentUsage -gt $threshold){"Page File Threshold reached"; exit 1}
else {"Page File Threshold NOT Reached"; exit 0}
