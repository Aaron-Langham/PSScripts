$thisPC = hostname; Get-WmiObject -Class Win32_DesktopMonitor | Select-Object ScreenWidth,ScreenHeight
$thisPC
