#
# JetBrains PyCharm IDE
#
class profile::ide::pycharm {
    # Lock down the version of Pycharm we actually want.
    # NOTE - version updates with Choco work great. They purge the old one.
    # If you installed Pycharm manually then you can end up with multiple
    # versions.

    # $pycharm_version = '2017.3.4'
    $pycharm_version = '2018.2.3'

    $package_name = $::osfamily ? {
        'windows' => 'PyCharm-community',
        'RedHat'  => 'pycharm-community',
        default   => fail('Unsupported OS')
    }

    package { $package_name:
        ensure => $pycharm_version
    }

    # The config dir does not do patch release number
    $config_version = $pycharm_version[0,6]

    file { 'PycharmConfigRoot':
        path   => "${turbosite::camper_homedir}/.PyCharmCE${config_version}",
        ensure => directory
    }

    file { 'PycharmConfig':
        path    => "${turbosite::camper_homedir}/.PyCharmCE${config_version}/config",
        ensure  => directory,
        source  => "puppet:///modules/cfcc/PyCharmCE${config_version}/config",
        recurse => 'remote',
        replace => 'no'
    }

    File['PycharmConfigRoot'] -> File['PycharmConfig']
}