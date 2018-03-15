#
#
#
class profiles::browsers::firefox {
    Package {
        provider => chocolatey
    }

    package { 'Firefox':
        ensure => 'present',
    }
}
