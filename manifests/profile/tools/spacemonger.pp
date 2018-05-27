#
#
#
class profile::tools::spacemonger {

    file { 'SpaceMonger-Dir':
        path   => "C:/Program Files (x86)/Spacemonger",
        ensure => directory,
    }

    file { 'SpaceMonger-Exe':
        path   => "C:/Program Files (x86)/Spacemonger/SpaceMonger.exe",
        source => "${::site::cfcc::nas_installers_path}\\SpaceMonger.exe",
    }

    shortcut { 'SpaceMonger-shortcut':
        path => 'C:/ProgramData/Microsoft/Windows/Start Menu/Programs/SpaceMonger.lnk',
        # icon_location => 'C:\ProgramData\scratch.ico',
        target => 'C:/Program Files (x86)/Spacemonger/SpaceMonger.exe'
    }

    File['SpaceMonger-Dir'] -> File['SpaceMonger-Exe'] -> Shortcut['SpaceMonger-shortcut']
}