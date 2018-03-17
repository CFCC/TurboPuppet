#
#
#
class profiles::browsers::chrome {

    $package_name = $::osfamily ? {
        'windows' => 'GoogleChrome',
        default   => fail('Unsupported OS')
    }

    package { $package_name: }
}
