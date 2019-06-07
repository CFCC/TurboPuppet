#
# JetBrains PyCharm IDE
#
class profile::ide::pycharm {
    # Lock down the version of Pycharm we actually want.
    # NOTE - version updates with Choco work great. They purge the old one.
    # If you installed Pycharm manually then you can end up with multiple
    # versions.

    # $pycharm_version = '2017.3.4'
    $pycharm_version = '2019.1.2'

    $package_name = $::operatingsystem ? {
        'windows' => 'PyCharm-community',
        'Fedora'  => 'pycharm-community',
        'Darwin'  => 'pycharm-ce',
        default   => fail('Unsupported OS')
    }

    package { $package_name:
        # Brew doesnt support ensuring specific versions. This
        # isn't ideal but we can at least deal with it.
        ensure => $::operatingsystem ? {
            'Darwin' => 'present',
            default  => $pycharm_version
        }
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
