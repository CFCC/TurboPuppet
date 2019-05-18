#
#
#
class profile::webserver::xampp {
    $package_name = $::osfamily ? {
        'windows' => 'Bitnami-XAMPP',
        default   => fail('Unsupported OS')
    }

    package { $package_name: }
}
