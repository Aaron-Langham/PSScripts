# Runs the sfc and dism commands to fix any issues with a file system

sfc /scannow
dism /online /cleanup-image /CheckHealth
dism /online /cleanup-image /ScanHealth
dism /online /cleanup-image /startcomponentcleanup
dism /online /cleanup-image /restorehealth
