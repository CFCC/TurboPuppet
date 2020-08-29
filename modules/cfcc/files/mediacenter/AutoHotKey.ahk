; AutoHotKey.ahk
; THIS FILE IS MANAGED BY PUPPET

ProcessExist(Name) {
    Process, Exist, %Name%
    return Errorlevel
}

; Close the active window. This has an advantage over Alt-F4 because
; it won't try to shut down Windows if there is nothing open.
^+!1::
    WinGetTitle, Title, A
    if (Title != "Program manager") {
        WinKill, A
    }
Return

^+!2::
        Run "C:\Windows\explorer.exe" "shell:appsFolder\EF712BA7.HDHomeRunDVR_23nna27hyxhag!App"
Return

^+!3::
	if WinExist("Plex Media Player") {
        WinActivate, Plex Media Player
    }
	else {
    	Run "C:\Program Files\Plex\Plex Media Player\PlexMediaPlayer.exe"
        Sleep 3000
        WinActivate, Plex Media Player
    }
Return

^+!4::
        Run "C:\Program Files (x86)\Kodi\Kodi.exe"
Return

^+!5::
    ; If Steam is running but window not selected
	if WinExist("Steam") or ProcessExist("steam.exe") {
        Run "C:\Program Files (x86)\Steam\Steam.exe" "steam://open/bigpicture"
    }
    ;else if ProcessExist("steam.exe") {
    ;    Run "C:\Program Files (x86)\Steam\Steam.exe" "steam://open/bigpicture"
    ;}
	else {
    	Run "C:\Program Files (x86)\Steam\Steam.exe"
        Sleep 3000
        WinActivate, Steam
    }
Return

^+!6::
    RunWait PowerShell.exe -Command C:\CampFitch\bin\bluetooth.ps1 -BluetoothStatus Off,, hide
Return

^+!7::
    RunWait PowerShell.exe -Command C:\CampFitch\bin\bluetooth.ps1 -BluetoothStatus On,, hide
Return

^+!r::
    Reload
Return
