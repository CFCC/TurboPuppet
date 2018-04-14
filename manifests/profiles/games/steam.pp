#
# Steam
#
class profile::games::steam {
    $package_name = $::osfamily ? {
        'windows' => 'steam',
        'Fedora'  => 'steam',
        default   => fail('Unsupported OS')
    }

    package { $package_name: }
}