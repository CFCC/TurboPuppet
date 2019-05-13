#!/usr/bin/env pwsh

# This requires AutoHotKey and EpigGamesLauncher to be installed.

# https://serverfault.com/questions/95431/in-a-powershell-script-how-can-i-check-if-im-running-with-administrator-privil
function Test-Is-Administrator
{
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    $result = (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    return $result
}

$is_admin = Test-Is-Administrator
if ($is_admin)
{
    Write-Host "Must not run as Administrative user"
    exit 1
}

# Delete C:\Program Files\Epic Games\*
Remove-Item -Path 'C:\users\camper\AppData\Local\EpicGamesLauncher' -Recurse -Force
Remove-Item -Path 'C:\ProgramData\Epic' -Recurse -Force
Remove-Item -Path 'C:\Program Files\Epic Games\*' -Recurse -Force

date

AutoHotKey C:\CampFitch\bin\egl-login.ahk

date

# @TODO figure out where the EGL login information gets stored
# C:\Users\camper\AppData\Local\EpicGamesLauncher\Saved/Config\Windows\GameUserSettings.ini
# [RememberMe] Data=base64 encoding of some stuff
 #>