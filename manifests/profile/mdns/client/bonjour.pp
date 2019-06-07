#
# Bonjour mDNS Service
#
class profile::mdns::client::bonjour {
    # 20180527 - v2.0.2 from 2016 is amazingly the "latest"
    $package_name = $::osfamily ? {
        'windows' => 'bonjour',
        default   => fail('Unsupported OS')
    }
    package { $package_name: }

    service { 'Bonjour Service':
        ensure => 'running',
        enable => 'true',
    }

    Package[$package_name] -> Service['Bonjour Service']
}
