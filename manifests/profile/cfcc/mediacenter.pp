#
#
#
class profile::cfcc::mediacenter {

    package { 'tightvnc': }
    package { 'plexmediaplayer': }
    package { 'hdhomerun-view': }
    package { 'setpoint': }
    package { 'spotify': }

    include profile::tool::autohotkey


    file { 'bluetooth.ps1':
        path => "C:/CampFitch/bin/bluetooth.ps1",
        owner => $turbosite::camper_username,
        source => 'puppet:///modules/cfcc/mediacenter/bluetooth.ps1'
    }
    file { 'AutoHotKey.ahk':
        path => "${turbosite::camper_homedir}/Documents/AutoHotKey.ahk",
        owner => $turbosite::camper_username,
        source => 'puppet:///modules/cfcc/mediacenter/AutoHotKey.ahk',
        notify => Exec['ReloadAutoHotkey'],
    }

    # SPDIF keepalive. Apparently the new version is virus'd up (1.0 7z)?
    # https://veg.by/files/winsoft/
    # Known issue. Read the comments. I used the old version and it seems to be working fine.
    # https://veg.by/en/projects/soundkeeper/
    file { 'SoundKeeper64.exe':
        path => "C:/Users/${turbosite::camper_username}/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/SoundKeeper64.exe",
        source => 'puppet:///campfs/SoundKeeper64.exe',
    }

    file { 'wallpaper.jpg':
        path => "C:/Users/${turbosite::camper_username}/Pictures/wallpaper.jpg",
        source => 'puppet:///campfs/boston-wallpaper.jpg',
    }
}
