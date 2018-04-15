#
#
#
class profile::ide::intellij {
    # Lock down the version we actually want.
    $version = '2017.3.3'

    $package_name = $::osfamily ? {
        'windows' => 'intellijidea-community',
        default   => fail('Unsupported OS')
    }

    package { $package_name:
        ensure => $version
    }

    case $::osfamily {
        'windows': {
            include profile::ide::intellij::windows
        }
        default: { }
    }
}