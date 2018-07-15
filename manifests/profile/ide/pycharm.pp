#
# JetBrains PyCharm IDE
#
class profile::ide::pycharm {
    # Lock down the version of Pycharm we actually want.
    # NOTE - version updates with Choco work great. They purge the old one.
    # If you installed Pycharm manually then you can end up with multiple
    # versions.

    # $pycharm_version = '2017.3.4'
    $pycharm_version = '2018.1.3'

    $package_name = $::osfamily ? {
        'windows' => 'PyCharm-community',
        'Debian'  => 'com.jetbrains.PyCharm-Community',
        default   => fail('Unsupported OS')
    }

    # Wow... Hard to imagine the easiest platform to do this with is fucking Windows.
    # JetBrains did Snaps on some platforms, so I thought I'd use that. But Puppet's
    # Snapd support is not really there and the only module that provided it really sucked.
    # So then I learned that Mint does Flatpak instead. It's like Snap, but not. Ok....
    # The only module for Flatpak attempts to install Flatpak (which I already have)
    # And the dev bro who made it has me load in all these random PPAs from another dev bro
    # on the internet. Thanks, but no thanks. So we're back to the old-skool way. Oh,
    # and this does not support versioning. RIP
    #
    # https://tickets.puppetlabs.com/browse/PUP-7435
    # https://github.com/kemra102/puppet-snapd/
    # https://github.com/brwyatt/puppet-flatpak

    if ($::osfamily == 'Debian') {
        exec { 'flatpak-install-pycharm':
            command => "/usr/bin/flatpak install flathub ${package_name}",
            onlyif  => '/usr/bin/test ! -d /var/lib/flatpak/app/com.jetbrains.PyCharm-Community/'
        }
    }
    else {
        package { $package_name:
            ensure => $pycharm_version
        }
    }

    # The config dir does not do patch release number
    $config_version = $pycharm_version[0,6]

    file { 'PycharmConfigRoot':
        path   => "C:/Users/${turbosite::camper_username}/.PyCharmCE${config_version}",
        ensure => directory
    }

    file { 'PycharmConfig':
        path    => "C:/Users/${turbosite::camper_username}/.PyCharmCE${config_version}/config",
        ensure  => directory,
        source  => "puppet:///modules/cfcc/PyCharmCE${config_version}/config",
        recurse => 'remote',
        replace => 'no'
    }

    File['PycharmConfigRoot'] -> File['PycharmConfig']
}