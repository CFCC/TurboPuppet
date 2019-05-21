#
#
#
class profile::cfcc::mediacenter {
    # tightvnc
    # autohotkey


    ### AutoHotKey.ahk

    # ProcessExist(Name) {
    #     Process, Exist, %Name%
    #     return Errorlevel
    # }
    #
    # ^+!1::
    #         Run "C:\Users\grant\Documents\bluetooth-toggle.vbs"
    # Return
    #
    # ^+!2::
    #         Run "C:\Windows\explorer.exe" "shell:appsFolder\EF712BA7.HDHomeRunDVR_23nna27hyxhag!App"
    # Return
    #
    # ^+!3::
    # 	if WinExist("Plex Media Player") {
    #         WinActivate, Plex Media Player
    #     }
    # 	else {
    #     	Run "C:\Program Files\Plex\Plex Media Player\PlexMediaPlayer.exe"
    #         Sleep 3000
    #         WinActivate, Plex Media Player
    #     }
    # Return
    #
    # ^+!4::
    #         Run "C:\Program Files (x86)\Kodi\Kodi.exe"
    # Return
    #
    # ^+!5::
    #     ; If Steam is running but window not selected
    # 	if WinExist("Steam") or ProcessExist("steam.exe") {
    #         Run "C:\Program Files (x86)\Steam\Steam.exe" "steam://open/bigpicture"
    #     }
    #     ;else if ProcessExist("steam.exe") {
    #     ;    Run "C:\Program Files (x86)\Steam\Steam.exe" "steam://open/bigpicture"
    #     ;}
    # 	else {
    #     	Run "C:\Program Files (x86)\Steam\Steam.exe"
    #         Sleep 3000
    #         WinActivate, Steam
    #     }
    # Return
    #
    # ; Why does an ID value change....
    # ^+!6::
    #     speakerScript =
    #     (
    #         Get-AudioDevice -List | Where-Object Name -like '*E600i-B3*' | Set-AudioDevice
    #     )
    #
    #     RunWait PowerShell.exe -Command &{%speakerScript%},, hide
    # Return
    #
    # ^+!7::
    #     headphonesScript =
    #     (
    #         Get-AudioDevice -List | Where-Object Name -like '*Headphones*' | Set-AudioDevice
    #     )
    #
    #     RunWait PowerShell.exe -Command &{%headphonesScript%},, hide
    # Return
    #
    # ^+!r::
    #     Reload
    # Return

    ###bluetooth-toggle.vbs
    # Set objShell = CreateObject("Wscript.shell")
    # objShell.run "powershell.exe -NoProfile -WindowStyle hidden -command C:\Users\grant\Documents\bluetooth.ps1 -BluetoothStatus toggle", 0, True

    ###bluetooth.ps1
    #!/usr/bin/env powershell

    # https://superuser.com/questions/1168551/turn-on-off-bluetooth-radio-adapter-from-cmd-powershell-in-windows-10

    # I really really really hate Windows...
    #
    # [CmdletBinding()] Param (
    #     [Parameter(Mandatory=$true)][ValidateSet('Off', 'On', 'Toggle')][string]$BluetoothStatus
    # )
    #
    # # Start the Bluetooth service if it is stopped
    # If ((Get-Service bthserv).Status -eq 'Stopped') { Start-Service bthserv }
    # Add-Type -AssemblyName System.Runtime.WindowsRuntime
    #
    # $asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | ? { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]
    # Function Await($WinRtTask, $ResultType) {
    #     $asTask = $asTaskGeneric.MakeGenericMethod($ResultType)
    #     $netTask = $asTask.Invoke($null, @($WinRtTask))
    #     $netTask.Wait(-1) | Out-Null
    #     $netTask.Result
    # }
    #
    # [Windows.Devices.Radios.Radio,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
    # [Windows.Devices.Radios.RadioAccessStatus,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
    #
    # Await ([Windows.Devices.Radios.Radio]::RequestAccessAsync()) ([Windows.Devices.Radios.RadioAccessStatus]) | Out-Null
    #
    # $radios = Await ([Windows.Devices.Radios.Radio]::GetRadiosAsync()) ([System.Collections.Generic.IReadOnlyList[Windows.Devices.Radios.Radio]])
    # $bluetooth = $radios | ? { $_.Kind -eq 'Bluetooth' }
    # [Windows.Devices.Radios.RadioState,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
    #
    # if ($BluetoothStatus -eq "Toggle") {
    #     if ($bluetooth.State -eq "On") {
    #         $BluetoothStatus = "Off"
    #     }
    #     else {
    #         $BluetoothStatus = "On"
    #     }
    # }
    #
    # Await ($bluetooth.SetStateAsync($BluetoothStatus)) ([Windows.Devices.Radios.RadioAccessStatus]) | Out-Null
    #
    # New-BurntToastNotification -Silent -SnoozeAndDismiss -text "Bluetooth is now $BluetoothStatus" -AppLogo "C:\Users\grant\Pictures\bluetooth.png"
}