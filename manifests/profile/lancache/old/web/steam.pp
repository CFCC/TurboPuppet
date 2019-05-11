#
#
#
class profile::lancache::web::steam {

    # Common vars
    $proxy_headers = [
        'Host $proxy_host', # @TODO all we are doing is changing $host to $proxy host. Implciations?
        'X-Real-IP $remote_addr',
        'X-Forwarded-For $proxy_add_x_forwarded_for'
    ]

    $add_headers = {
        'X-Upstream-Status'        => '$upstream_status',
        'X-Upstream-Response-Time' => '$upstream_response_time',
        'X-Upstream-Cache-Status'  => '$upstream_cache_status'
    }

    $proxy_cache_valid = [
        '200 90d',
        '301 302 0'
    ]

    $proxy_cache_use_stale = 'error timeout invalid_header updating http_500 http_502 http_503 http_504'

    # Hash of all locations. Do not include the / location here.
    $steam_locations = {
        depot      => {
            location                 => '/depot/',
            proxy_ignore_header      => ['Expires'],
            proxy_cache_key          => '$server_name$uri',
            proxy                    => 'http://$host$request_uri',
            proxy_cache              => 'installs',
            proxy_redirect           => 'off',
            proxy_set_header         => $proxy_headers,
            add_header               => $add_headers,
            proxy_cache_lock         => 'on',
            proxy_cache_use_stale    => $proxy_cache_use_stale,
            proxy_cache_valid        => $proxy_cache_valid,
            proxy_cache_bypass       => '$arg_nocache',
            proxy_max_temp_file_size => '40960m',
        },
        serverlist => {
            location            => '/serverlist/',
            proxy_redirect      => 'off',
            proxy_set_header    => $proxy_headers,
            add_header          => $add_headers,
            proxy               => 'http://$host$request_uri',
            location_cfg_append => {
                'proxy_store'        => '/mnt/LanCache/cache/steam$uri/servers.txt',
                'proxy_store_access' => 'user:rw group:rw all:r',
            }
        },
    }

    # Server definition. The / location gets set implicitly here.
    nginx::resource::server { 'lancache-steam':
        listen_ip                => undef,
        server_name              => ['steam', '_'],
        access_log               => '/var/log/lancache/steam-access.log',
        error_log                => '/var/log/lancache/steam-error.log',
        locations                => $steam_locations,
        resolver                 => ['8.8.8.8', '8.8.4.4', 'ipv6=off'],
        proxy_cache_key          => '$server_name$request_uri',
        proxy_cache              => 'other',
        proxy                    => 'http://$host$request_uri',
        proxy_redirect           => 'off',
        proxy_set_header         => $proxy_headers,
        add_header               => $add_headers,
        proxy_cache_lock         => 'on',
        proxy_cache_use_stale    => $proxy_cache_use_stale,
        proxy_cache_valid        => $proxy_cache_valid,
        proxy_cache_bypass       => '$arg_nocache',
        proxy_max_temp_file_size => '40960m',
    }
}