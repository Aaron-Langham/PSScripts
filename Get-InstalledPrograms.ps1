# Gets a list of installed programs
 
 Get-WmiObject -Class Win32_Product -Property Name | Select-Object name
