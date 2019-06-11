#
#
#
class profile::ide::intellij {
    # Lock down the version we actually want.
    # $intellij_version = '2018.1.1'
    $intellij_version = '2019.1.3'

    $package_name = $::operatingsystem ? {
        'windows' => 'intellijidea-community',
        'Fedora'  => 'intellij-idea-community',
        'Darwin'  => 'intellij-idea-ce',
        default   => fail('Unsupported OS')
    }

    # Like Pycharm, Brew doesnt support ensure => version.
    package { $package_name:
        ensure => $::operatingsystem ? {
            'Darwin' => present,
            default  => $intellij_version
        }
    }

    # Install any dependencies
    case $::operatingsystem {
        'Fedora': {
            package { 'java-1.8.0-openjdk-devel': }
        }
        default: {}
    }

    # @TODO maybe figure out a way to auto-detect the installed JDK so that we don't have to set it manually.
}
