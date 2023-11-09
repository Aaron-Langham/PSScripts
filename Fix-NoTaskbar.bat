# Force restarts Windows File Explorer to fix a bug where the task bar is missing.

taskkill /f /im explorer.exe
explorer.exe
