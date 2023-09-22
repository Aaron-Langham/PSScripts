#Sets Execution Policy to allow script to run
Set-ExecutionPolicy -Scope CurrentUser -Force Unrestricted -Confirm:$False

#start-sleep -Seconds 10

#Sets current user name to varible, converts to string, finds index of "\", adds 1 to get the index of the first character in name
$user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$user.ToString()
$i = $user.IndexOf("\")
$i+=1

#Creates blank string varible
$userNew = ""

#For loop to start at the index of first character of username and end at the length of the username
for ($i; $i -lt $user.Length; $i++)
{
    $userNew = $userNew + $user[$i] #adds the indexed character to new varible
}

$userNew

$TempFolder = "C:\Users\"+$userNew+"\AppData\Local\Temp\"
$SageFolder = "C:\Users\"+$userNew+"\AppData\Local\Sage\Sage200\"
Get-ChildItem $TempFolder | Remove-Item -Recurse -Force
Get-ChildItem $SageFolder | Remove-Item -Recurse -Force

#start-sleep -Seconds 10

Set-ExecutionPolicy -Scope CurrentUser -Force Undefined -Confirm:$False

#start-sleep -Seconds 20
