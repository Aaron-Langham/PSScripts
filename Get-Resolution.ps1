# Gets the Screen resolution of a PC
 
$screenResolution = hostname; Get-WmiObject -Class Win32_DesktopMonitor | Select-Object ScreenWidth,ScreenHeight
$screenResolution
