#
#
#
class profile::lancache::dns {
    # Tools
    package { 'bind-tools': }

    $stub_zones = {
        "boston.grantcohoe.com" => {
            address  => '192.168.1.1',
            insecure => true,
        },
        "localdomain" => {
            address  => '10.0.0.1',
            insecure => true,
        },
        "10.in-addr.arpa." => 
            address  => '10.0.0.1',
            insecure => true,
        }
    }

    class { 'unbound':
        interface               => ['0.0.0.0'],
        access                  => [
            '10.0.0.0/8',
            '::1',
            '192.168.0.0/16',
            '172.16.0.0/12'
        ],
        skip_roothints_download => true,
        custom_server_conf      => [
            'include: "/usr/local/etc/unbound/conf.d/*.conf"'
        ]
    }

    Unbound::Record {
        ttl     => 60,
        type    => 'A',
        content => $::ipaddress
    }

    create_resources(unbound::stub, $stub_zones)

    unbound::forward { '.':
        address => $turbosite::upstream_dns
    }

    # https://protoxin.net/setting-up-a-freebsd-dns-adblocker/
    file { 'Blacklist':
        path   => '/usr/local/etc/unbound/conf.d/10_blacklist.conf',
        source => 'puppet:///modules/cfcc/unbound/10_blacklist.conf',
        notify => Service['unbound'],
    }
    file { 'Lancache':
        path   => '/usr/local/etc/unbound/conf.d/20_lancache.conf',
        source => 'puppet:///modules/cfcc/unbound/20_lancache.conf',
        notify => Service['unbound'],
    }

    # unbound-control has some bugs. It can't read the server config file
    # because it doesnt know about all of its options. Oh and the paths
    # in the remote_control section always append what it thinks is the
    # root directory which is wrong! So you get like /var/unbound/usr/local/etc/unbound
    file { '/var/unbound/unbound_control.pem':
        ensure => link,
        target => '/usr/local/etc/unbound/unbound_control.pem',
        require => Class['unbound']
    }
    file { '/var/unbound/unbound_control.key':
        ensure => link,
        target => '/usr/local/etc/unbound/unbound_control.key',
        require => Class['unbound']
    }
    file { '/var/unbound/unbound_server.pem':
        ensure => link,
        target => '/usr/local/etc/unbound/unbound_server.pem',
        require => Class['unbound']
    }
    file { '/var/unbound/unbound_server.key':
        ensure => link,
        target => '/usr/local/etc/unbound/unbound_server.key',
        require => Class['unbound']
    }
    file { '/var/unbound/unbound.conf':
        source => 'puppet:///modules/cfcc/unbound/control.conf',
        require => Class['unbound']
    }
}
