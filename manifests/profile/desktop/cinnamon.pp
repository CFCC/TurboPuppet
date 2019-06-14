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

    # Disable the sound that sounds when you adjust the volume sound.
    # Is that enough sound?
    dconf::setting { 'DisableVolumeSound':
        key   => '/org/cinnamon/desktop/sound/volume-sound-enabled',
        value => false,
    }

    # Desktop icons for common stuff
    $desktop_icons = ['computer', 'home', 'trash']
    $desktop_icons.each |String $icon| {
        dconf::setting { "DisableIcon-${icon}":
            key   => "/org/nemo/desktop/${icon}-icon-visible",
            value => false,
        }
    }

    # Thumbnailer backend
    package { 'ffmpegthumbnailer': }

    # Thumbnails everywhere
    dconf::setting { 'show-image-thumbnails':
        key     => '/org/nemo/preferences/show-image-thumbnails',
        value   => 'always',
        require => Package['ffmpegthumbnailer']
    }

}