#
#
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
        default   => fail('Unsupported OS')
    }

    package { $package_name:
        ensure => $pycharm_version
    }

    # case $::osfamily {
    #     'windows': {
    #         # Desktop shortcut
    #         # This does not deal with upgrades well. Deleting until another day
    #         # shortcut { "C:/Users/Public/Desktop/PyCharm Community Edition ${pycharm_version}.lnk":
    #         #     target => "C:/Program Files (x86)/JetBrains/PyCharm Community Edition ${pycharm_version}/bin/pycharm64.exe"
    #         # }
    #         # @TODO maybe figure out a way to auto-detect the installed Python so that we don't have to set it manually.
    #     }
    #     default: { }
    # }
}