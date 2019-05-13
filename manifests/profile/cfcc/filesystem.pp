#
#
#
class profile::cfcc::filesystem {

    case $::kernel {
        'windows': {
            file { ['C:/CampFitch', 'C:/CampFitch/bin']:
                ensure => directory,
                owner  => $turbosite::camper_username,
                group  => 'administrators',
            }
        }
        'Linux': {
            file { ['/usr/cfcc', '/usr/cfcc/bin']:
                ensure => directory,
                owner  => $turbosite::camper_username,
                group  => 'wheel',
            }
        }
        'Darwin': {
            file { ['/usr/cfcc', '/usr/cfcc/bin']:
                ensure => directory,
                owner  => $turbosite::camper_username,
                group  => 'wheel',
            }
        }
        'FreeBSD': {
            file { ['/usr/cfcc', '/usr/cfcc/bin']:
                ensure => directory,
                owner  => $turbosite::camper_username,
                group  => 'wheel',
            }
        }
        default: { fail("Unsupported OS ${::kernel}") }
    }

}