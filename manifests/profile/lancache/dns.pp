#
#
#
class profile::lancache::dns {
    # Tools
    package { 'bind-tools': }

    $steam_zones = {
        'content1.steampowered.com'           => 'redirect',
        'content2.steampowered.com'           => 'redirect',
        'content3.steampowered.com'           => 'redirect',
        'content4.steampowered.com'           => 'redirect',
        'content5.steampowered.com'           => 'redirect',
        'content6.steampowered.com'           => 'redirect',
        'content7.steampowered.com'           => 'redirect',
        'content8.steampowered.com'           => 'redirect',
        'cs.steampowered.com'                 => 'redirect',
        'hsar.steampowered.com.edgesuite.net' => 'redirect',
        'akamai.steamstatic.com'              => 'redirect',
        'steamcontent.com'                    => 'redirect',
        'edgecast.steamstatic.com'            => 'redirect',
        'steampipe.akamaized.net'             => 'redirect',
    }

    $stub_zones = {
        "grantcohoe.com" => {
            address  => '192.168.1.1',
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
        local_zone              => $steam_zones,
        skip_roothints_download => true,
    }

    Unbound::Record {
        ttl     => 60,
        type    => 'A',
        content => $::ipaddress
    }

    $steam_zones.keys.each |String $zone| {
        unbound::record { $zone: }
    }

    create_resources(unbound::stub, $stub_zones)
}