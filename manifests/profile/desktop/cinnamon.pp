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

    # @TODO make this less disgusting
    dconf::setting { 'PanelApplets':
        key   => '/org/cinnamon/enabled-applets',
        value => "['panel1:right:0:systray@cinnamon.org:0', 'panel1:left:0:menu@cinnamon.org:1', 'panel1:right:1:keyboard@cinnamon.org:4', 'panel1:right:2:notifications@cinnamon.org:5', 'panel1:right:3:removable-drives@cinnamon.org:6', 'panel1:right:5:network@cinnamon.org:7', 'panel1:right:6:blueberry@cinnamon.org:8', 'panel1:right:7:power@cinnamon.org:9', 'panel1:right:8:calendar@cinnamon.org:10', 'panel1:right:9:sound@cinnamon.org:11']",
    }

    file { 'CinnamonMenuConfig':
        path   => "${::turbosite::camper_homedir}/.cinnamon/configs/menu@cinnamon.org/1.json",
        source => 'puppet:///modules/cfcc/cinnamon/menu.json',
        owner  => $::turbosite::camper_username
    }

    # The stock wallpapers for FC30 suck.
    file { 'CamperWallpaper':
        path   => '/usr/share/backgrounds/images/camper.jpg',
        source => 'puppet:///campfs/fedora-wallpaper.jpg'
    } ->
    dconf::setting { 'WallpaperMode':
        key   => '/org/cinnamon/desktop/background/picture-options',
        value => 'zoom'
    } ->
    dconf::setting { 'Wallpaper':
        key   => '/org/cinnamon/desktop/background/picture-uri',
        value => 'file:///usr/share/backgrounds/images/camper.jpg'
    }

    $nemo_settings = {
        'default-folder-viewer'         => 'list-view',
        'click-double-parent-folder'    => true,
        'swap-trash-delete'             => true,
        'show-image-thumbnails'         => 'always',
        'thumbnail-limit'               => 'uint64 34359738368',
        'tooltips-in-list-view'         => true,
        'tooltips-show-file-type'       => true,
        'tooltips-show-birth-date'      => true,
        'show-open-in-terminal-toolbar' => true,
    }
    $nemo_settings.each |String $key, $value| {
        dconf::setting { $key:
            key   => "/org/nemo/preferences/$key",
            value => $value
        }
    }

    dconf::setting { 'screensaver-idle':
        key   => "/org/cinnamon/desktop/session/idle-delay",
        value => 'uint32 0'
    }

    # Desktop icons
    # https://forums.linuxmint.com/viewtopic.php?t=261784
    file_line { 'NemoDesktopAutoArrange':
        path   => "${turbosite::camper_homedir}/.config/nemo/desktop-metadata",
        line   => 'nemo-icon-view-auto-layout=false',
        match  => '^nemo-icon-view-auto-layout.*$',
        notify => Exec['Reload Nemo'],
    } ->
    file_line { 'NemoDesktopGridSize':
        path   => "${turbosite::camper_homedir}/.config/nemo/desktop-metadata",
        line   => 'desktop-grid-adjust=93;100;',
        match  => '^desktop-grid-adjust.*$',
        notify => Exec['Reload Nemo'],
    }

    exec { 'Reload Nemo':
        command     => '/usr/bin/killall nemo-desktop; /usr/bin/nohup /usr/bin/nemo-desktop 2>&1 >/dev/null &',
        refreshonly => true,
        user        => $turbosite::camper_username,
        environment => [
            "XDG_RUNTIME_DIR=/run/user/${turbosite::camper_uid}"
        ],
    }

}