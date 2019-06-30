#
#
#
class profile::cfcc::mediacenter {

    package { 'tightvnc': }
    package { 'plexmediaplayer': }
    package { 'hdhomerun-view': }

    include profile::tool::autohotkey

    file { 'AutoHotKey.ahk':
        path => "${turbosite::camper_homedir}/Documents/AutoHotKey.ahk",
        owner => $turbosite::camper_username,
        source => 'puppet:///modules/cfcc/mediacenter/AutoHotKey.ahk'
    }
}