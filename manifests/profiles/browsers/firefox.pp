#
#
#
class profiles::browsers::firefox {

    $package_name = $::osfamily ? {
        'windows' => 'Firefox',
        default   => fail('Unsupported OS')
    }

    package { $package_name: }
}
