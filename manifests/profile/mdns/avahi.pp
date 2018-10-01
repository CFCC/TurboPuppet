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

    # So, fc28 has enabled a fancy new tool for automagic authentication configuration
    # called authselect. It has the ability to automagically generate the nsswitch.conf
    # and a ton of PAM configs.
    # https://github.com/pbrezina/authselect/wiki/Design-Document:-nsswitch.conf-modification
    # Until that becomes a thing, we're gonna go with the old fashioned way.
    file_line { 'nss-hosts':
        path => '/etc/nsswitch.conf',
        line => 'hosts:      files mdns4_minimal [NOTFOUND=return] dns myhostname',
        match => '^hosts:'
    }

    Package[$package_name] -> Service['avahi-daemon']
}