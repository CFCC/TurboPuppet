# THIS FILE IS DEPREACTED
Set objShell = CreateObject("Wscript.shell")
objShell.run "powershell.exe -NoProfile -WindowStyle hidden -command C:\Users\grant\Documents\bluetooth.ps1 -BluetoothStatus toggle", 0, True
