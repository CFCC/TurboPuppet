#
# Steam
#
class profile::games::steam {
    $package_name = $::kernel ? {
        'windows' => 'steam',
        'Linux'   => 'steam',
        default   => fail('Unsupported OS')
    }

    package { $package_name: }
}