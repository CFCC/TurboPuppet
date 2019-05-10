#
#
#
class profile::ide::intellij {
    # Lock down the version we actually want.
    # $intellij_version = '2018.1.1'
    $intellij_version = '2019.1.2'

    $package_name = $::osfamily ? {
        'windows' => 'intellijidea-community',
        'Darwin'  => 'intellij-idea-ce',
        default   => fail('Unsupported OS')
    }

    # Like Pycharm, Brew doesnt support ensure => version.
    package { $package_name:
        ensure => $::osfamily ? {
            'Darwin' => present,
            default  => $intellij_version
        }
    }

    # @TODO maybe figure out a way to auto-detect the installed JDK so that we don't have to set it manually.
}