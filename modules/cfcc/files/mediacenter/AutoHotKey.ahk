# AutoHotKey.ahk
# THIS FILE IS MANAGED BY PUPPET

ProcessExist(Name) {
    Process, Exist, %Name%
    return Errorlevel
}

^+!1::
        Run "C:\Users\camper\Documents\bluetooth-toggle.vbs"
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

; Why does an ID value change....
^+!6::
    speakerScript =
    (
        Get-AudioDevice -List | Where-Object Name -like '*E600i-B3*' | Set-AudioDevice
    )

    RunWait PowerShell.exe -Command &{%speakerScript%},, hide
Return

^+!7::
    headphonesScript =
    (
        Get-AudioDevice -List | Where-Object Name -like '*Headphones*' | Set-AudioDevice
    )

    RunWait PowerShell.exe -Command &{%headphonesScript%},, hide
Return

^+!r::
    Reload
Return