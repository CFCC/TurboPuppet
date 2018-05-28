#
# Google Chrome web browser
#
class profile::browsers::chrome {

    $package_name = $::kernel ? {
        'windows' => 'GoogleChrome',
        'Linux'   => 'google-chrome-stable',
        default   => fail('Unsupported OS')
    }

    package { $package_name: }
}
