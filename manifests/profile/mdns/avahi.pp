#
# Avahi mDNS Service
# NOTE - This does NOT imply automatic local name resolution!
# This will reply when someone asks for you.local, but you need
# to mess with /etc/nsswitch.conf in order to resolve other hosts.
#
class profile::mdns::avahi {
    $package_name = $::osfamily ? {
        'RedHat' => 'avahi',
        default   => fail('Unsupported OS')
    }
    package { $package_name: }

    service { 'avahi-daemon':
        ensure => 'running',
        enable => 'true',
    }

    Package[$package_name] -> Service['avahi-daemon']
}