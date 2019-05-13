; fortnite-init
; This is loosely based on https://github.com/OpenSourceLAN/steam-auto-hot-key/tree/master/epic
; with the added caveat that I want to terminate the EpicGamesLauncher install process after it
; starts so I can copy over Fortnite from my LAN cache.
;
; Our initial research showed that you can't just drop Fortnite into the install directory
; and have EGL not re-download the whole thing. But if you trick it into starting the install
; then magically make more files appear then it seemed to work fine. Not sure if there's a
; hidden flag somewhat in EGL that makes this work better. Not really invested in figuring
; that out yet. This method at least covers the major bandwidth case.
;
; This script is not meant to be called by automation.

; pass username and password as command line args
; e.g. epic_launcher_login.ahk username@gmail.com password1

uname = %1%
pword = %2%

cleanup_script =
(
    Remove-Item -Path 'C:\users\camper\AppData\Local\EpicGamesLauncher' -Recurse -Force
    Remove-Item -Path 'C:\ProgramData\Epic' -Recurse -Force
    Remove-Item -Path 'C:\Program Files\Epic Games\*' -Recurse -Force
)

; https://stackoverflow.com/questions/32397032/run-a-powershell-command-through-autohotkey-script
RunWait PowerShell.exe -Command &{%cleanup_script%}

Run, EpicGamesLauncher.exe com.epicgames.launcher://fortnite, C:\Program Files (x86)\Epic Games\Launcher\Portal\Binaries\Win32

WinWait,Epic Games Launcher
WinActivate,Epic Games Launcher
; Can't use WinMaximize becuase desktop size is variable
WinMove,Epic Games Launcher,, 100, 100, 1000, 800,,

Sleep 2000

; This selects an arbitrary point in the application.
MouseMove, 100, 100
Click

; Log in
Send {Tab}
Send % uname
Send {Tab}
Send % pword
Send {Enter}

; On first run it will ask for an install location
; We accept the default of C:\Program Files\Epic Games
; Even though the docs and cursor tracker say absolute
; positioning, I find I still have to subtract the
; inital 100x100 spacing we did earlier....
Sleep 5000
MouseMove, 610, 520
Click

;wait for the friends window to appear then kill it.
WinWait,Add Friend
WinActivate,Add Friend
WinClose,Add Friend

; Now we need to go pause the download
; Same weird stuff with the cursor position
Sleep 4000
MouseMove, 100, 280
Click
; Now wait a little bit for the download process to start
Sleep 5000
MouseMove, 440, 230
Click

; Shoot EGL
RunWait PowerShell.exe -Command &{%local_copy%}

; Transfer
; To get visual progress, this is way easier than the many attempts
; the Powershell world gave me. I fscking hate Windows...
; The path must be cygwin-esque https://stackoverflow.com/questions/10233330/cygwin-file-copy-to-unc-share
RunWait rsync -ruaPv '//TARS/CampFitch/Camp Games/Fortnite/' '/cygdrive/c/Program Files/Epic Games/Fortnite'

; Fire up EGL and let it revalidate
Run, EpicGamesLauncher.exe, C:\Program Files (x86)\Epic Games\Launcher\Portal\Binaries\Win32
WinWait,Epic Games Launcher
WinActivate,Epic Games Launcher
WinMove,Epic Games Launcher,, 100, 100, 1000, 800,,

; Navigate to library. It can take a bit for the app to boot up though.
Sleep 10000
MouseMove, 100, 280
Click

; Resume
Sleep 2000
MouseMove, 340, 230
Click