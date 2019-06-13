#
#
#
class profile::desktop::cinnamon {

    Dconf::Setting {
        user => $::turbosite::camper_username,
        uid  => $::turbosite::camper_uid
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

}