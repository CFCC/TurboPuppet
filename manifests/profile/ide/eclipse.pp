#
# Eclipse Java IDE
#
class profile::ide::eclipse {

    $package_name = $::osfamily ? {
        'windows' => 'eclipse',
        default   => fail('Unsupported OS')
    }

    package { $package_name: }

}