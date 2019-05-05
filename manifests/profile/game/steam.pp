#
# Steam
#
class profile::game::steam {
    $package_name = $::kernel ? {
        'windows' => 'steam',
        'Linux'   => 'steam',
        default   => fail('Unsupported OS')
    }

    package { $package_name: }
}