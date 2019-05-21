#
# Steam
#
class profile::game::steam {
    $package_name = $::kernel ? {
        default => 'steam'
    }

    package { $package_name: }

    case $::kernel {
        'windows': {
            # Disable autostart
            hkcu { 'SteamAutostart':
                ensure => absent,
                key    => 'Software\Microsoft\Windows\CurrentVersion\Run',
                value  => 'Steam',
            }
        }
        default: {}
    }
}
