#
#
#
class profile::tool::spacemonger {

    file { 'SpaceMonger-Dir':
        path   => "C:/Program Files (x86)/Spacemonger",
        ensure => directory,
    }

    file { 'SpaceMonger-Exe':
        path   => 'C:/Program Files (x86)/Spacemonger/SpaceMonger.exe',
        source => 'puppet:///campfs/SpaceMonger.exe',
    }

    shortcut { 'SpaceMonger-shortcut':
        path => 'C:/ProgramData/Microsoft/Windows/Start Menu/Programs/SpaceMonger.lnk',
        target => 'C:/Program Files (x86)/Spacemonger/SpaceMonger.exe'
    }

    File['SpaceMonger-Dir'] -> File['SpaceMonger-Exe'] -> Shortcut['SpaceMonger-shortcut']
}