#
#
#
class profile::desktop::cinnamon {
    # Exec {
    # user => $::turbosite::camper_username
    # user => 'camper'
    # }

    # exec { 'SetClockFormat':
    #     command => '/usr/bin/dbus-launch /usr/bin/dconf write /org/cinnamon/desktop/interface/clock-use-24h true',
    #     onlyif => '/usr/bin/test $(dconf read /org/cinnamon/desktop/interface/clock-use-24h) != true'
    # }

    Dconf::Setting {
        user => 'camper'
    }

    # Change the clock to 12-hour format
    dconf::setting { 'SetClockFormat':
        key   => '/org/cinnamon/desktop/interface/clock-use-24h',
        value => false,
    }

    # Disable all of the annoying sounds the desktop makes
    $disable_sounds = [
        'login',
        'logout',
        'switch',
        'map',
        'close',
        'minimize',
        'maximize',
        'unmaximize',
        'tile',
        'plug',
        'unplug',
        'notification',
    ]
    $disable_sounds.each |String $sound| {
        dconf::setting { "DisableSound-${sound}":
            key   => "/org/cinnamon/sounds/${sound}-enabled",
            value => false,
        }
    }

    dconf::setting { 'DisableVolumeSound':
        key   => '/org/cinnamon/desktop/sound/volume-sound-enabled',
        value => false,
    }

    # Remove crap we don't want
    package { 'thunderbird': ensure => purged }

}