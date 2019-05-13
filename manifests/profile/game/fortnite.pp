#
#
#
class profile::game::fortnite {
    package { 'epicgameslauncher': }

    # See the profile::packages for what the flying saucer here means
    Package <| name == 'rsync' |>

    file { ['C:/CampFitch', 'C:/CampFitch/bin']:
        ensure  => directory,
        owner   => 'camper',
        group   => 'administrators',
        recurse => true
    }

    file { 'fortnite-init':
        path    => 'C:/CampFitch/bin/fortnite-init.ahk',
        source  => 'puppet:///modules/cfcc/fortnite/gl-login.ahk',
        require => File['egl-login']
    }
}