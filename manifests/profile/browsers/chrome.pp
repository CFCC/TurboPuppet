#
# Google Chrome web browser
#
class profile::browsers::chrome {

    $package_name = $::osfamily ? {
        'windows' => 'GoogleChrome',
        default   => fail('Unsupported OS')
    }

    package { $package_name: }
}
