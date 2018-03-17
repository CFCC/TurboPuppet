#
#
#
class profiles::ide::pycharm {

    # Lock down the version of Pycharm we actually want.
    $pycharm_version = '2017.3.4'

    $package_name = $::osfamily ? {
        'windows' => 'PyCharm-community',
        default   => fail('Unsupported OS')
    }

    package { $package_name:
        ensure => $pycharm_version
    }
}