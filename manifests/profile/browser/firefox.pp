#
#
#
class profile::browser::firefox {

    $package_name = $::kernel ? {
        'windows' => 'Firefox',
        'Linux'   => 'firefox',
        'Darwin'  => 'firefox',
        default   => fail('Unsupported OS')
    }

    package { $package_name: }

    # Desktop Shortcut
    case $::operatingsystem {
        'Fedora': {
            file { "${turbosite::camper_homedir}/Desktop/firefox.desktop":
                source => 'file:///usr/share/applications/firefox.desktop',
                mode   => '0755',
                owner  => $turbosite::camper_username
            }
        }
        default: {}
    }
}
