#
#
#
class profile::browser::firefox {

    $package_name = $::kernel ? {
        'windows' => 'Firefox',
        'Linux'   => 'firefox',
        default   => fail('Unsupported OS')
    }

    package { $package_name: }
}
