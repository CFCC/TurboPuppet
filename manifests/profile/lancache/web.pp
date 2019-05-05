#
#
#
class profile::lancache::web {
    #include profile::webserver::nginx
    
    file { '/mnt/LanCache/cache/':
        ensure => directory
    }

    class { '::nginx':
        log_format => { # https://github.com/multiplay/lancache/blob/master/lancache/logging
            'main' => '$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" "$upstream_cache_status" "$host" "$http_range" "$request_time" "$upstream_response_time"'
            #'main' => '$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" "$upstream_cache_status" "$host" "$http_range" "$range_cache_range" "$request_time" "$upstream_response_time"'
        },
        proxy_temp_path => '/mnt/LanCache/cache/tmp'
    }

    $proxy_cache_paths = {
        installs => {
            path => '/mnt/LanCache/cache/installs',
            levels => '2:2',
            size => '4096m', # num of files?
            inactive => '120d',
            max_size => '5767168m',
            extras => [
                'loader_files=1000',
                'loader_sleep=50ms',
                'loader_threshold=300ms'
            ]
        },
        other => {
            path => '/mnt/LanCache/cache/other',
            levels => '2:2',
            size => '100m',
            inactive => '72h',
            max_size => '10240m'
        }
    }

    file { 'proxy-cache.conf':
        path => '/usr/local/etc/nginx/conf.d/proxy-cache.conf',
        content => template('cfcc/nginx/proxy-cache.conf.erb'),
        notify => Service['nginx']
    }

    file { '/var/log/lancache':
        ensure => directory,
        owner => $::nginx::params::daemon_user,
        group => $::nginx::params::daemon_group,
    }

    $steam_locations = {
#        'depot' => {
#            location => '/depotlolz/',
#            proxy_ignore_header => ['Expires'],
#            proxy_cache_key => '$server_name$uri',
#        }
    }

    nginx::resource::server { 'lancache-steam':
        listen_ip => undef,
        server_name => ['steam', '_'],
        access_log => '/var/log/lancache/steam-access.log',
        error_log => '/var/log/lancache/steam-error.log',
        locations => $steam_locations,

        # BEGIN https://github.com/multiplay/lancache/blob/master/lancache/resolver
        resolver => ['8.8.8.8', '8.8.4.4', 'ipv6=off']
        # END https://github.com/multiplay/lancache/blob/master/lancache/resolver
    }

    nginx::resource::location { 'testing':

            # BEGIN https://github.com/multiplay/lancache/blob/master/lancache/node-steam
            server => 'lancache-steam',
            location => '/depot/',
            proxy_ignore_header => ['Expires'],
            proxy_cache_key => '$server_name$uri',
            # END https://github.com/multiplay/lancache/blob/master/lancache/node-steam

            # BEGIN https://github.com/multiplay/lancache/blob/master/lancache/cache-installs
            proxy => 'http://$host$request_uri',
            # END https://github.com/multiplay/lancache/blob/master/lancache/cache-installs

            # BEGIN https://github.com/multiplay/lancache/blob/master/lancache/cache-installs-base
            proxy_cache => 'installs',
            # END https://github.com/multiplay/lancache/blob/master/lancache/cache-installs-base

            # BEGIN https://github.com/multiplay/lancache/blob/master/lancache/proxy-base
            proxy_redirect => 'off',
            proxy_set_header => [
                'Host $proxy_host', # @TODO all we are doing is changing $host to $proxy host. Implciations?
                'X-Real-IP $remote_addr',
                'X-Forwarded-For $proxy_add_x_forwarded_for'
            ],
            add_header => {
                'X-Upstream-Status' => '$upstream_status',
                'X-Upstream-Response-Time' => '$upstream_response_time',
                'X-Upstream-Cache-Status' => '$upstream_cache_status'
            },
            # proxy_ignore_client_abort => on Not supported by Puppet
            # END https://github.com/multiplay/lancache/blob/master/lancache/proxy-base

            # BEGIN https://github.com/multiplay/lancache/blob/master/lancache/proxy-cache
            proxy_cache_lock => 'on',
            # proxy_cache_lock_timeout => 1h Not Supported
            proxy_cache_use_stale => 'error timeout invalid_header updating http_500 http_502 http_503 http_504',
            proxy_cache_valid => [
                '200 90d',
                '301 302 0'
            ],
            # proxy_cache_revalidate not supported by Puppet
            proxy_cache_bypass => '$arg_nocache',
            proxy_max_temp_file_size => '40960m',
            # proxy_cache_purge not supported
            # END https://github.com/multiplay/lancache/blob/master/lancache/proxy-cache
    }

    nginx::resource::location { 'serverlist':

            # BEGIN https://github.com/multiplay/lancache/blob/master/lancache/node-steam
            server => 'lancache-steam',
            location => '/serverlist/',
            # proxy_store => /data/www/cache/steam$uri/servers.txt; Not supported
            # proxy_store_access user:rw group:rw all:r;

            # BEGIN https://github.com/multiplay/lancache/blob/master/lancache/proxy-base
            proxy_redirect => 'off',
            proxy_set_header => [
                'Host $proxy_host', # @TODO all we are doing is changing $host to $proxy host. Implciations?
                'X-Real-IP $remote_addr',
                'X-Forwarded-For $proxy_add_x_forwarded_for'
            ],
            add_header => {
                'X-Upstream-Status' => '$upstream_status',
                'X-Upstream-Response-Time' => '$upstream_response_time',
                'X-Upstream-Cache-Status' => '$upstream_cache_status'
            },
            # proxy_ignore_client_abort => on Not supported by Puppet
            # END https://github.com/multiplay/lancache/blob/master/lancache/proxy-base
            proxy => 'http://$host$request_uri',
    }

    nginx::resource::location { 'steamroot':
        server => 'lancache-steam',
        location => '/',

        # BEGIN https://github.com/multiplay/lancache/blob/master/lancache/cache-key-default
        proxy_cache_key => '$server_name$request_uri',
        # END https://github.com/multiplay/lancache/blob/master/lancache/cache-key-default

        # BEGIN https://github.com/multiplay/lancache/blob/master/lancache/cache-other
        proxy_cache => 'other',
        proxy => 'http://$host$request_uri',
        # # END https://github.com/multiplay/lancache/blob/master/lancache/cache-other
        # BEGIN https://github.com/multiplay/lancache/blob/master/lancache/proxy-base
        proxy_redirect => 'off',
        proxy_set_header => [
            'Host $proxy_host', # @TODO all we are doing is changing $host to $proxy host. Implciations?
            'X-Real-IP $remote_addr',
            'X-Forwarded-For $proxy_add_x_forwarded_for'
        ],
        add_header => {
            'X-Upstream-Status' => '$upstream_status',
            'X-Upstream-Response-Time' => '$upstream_response_time',
            'X-Upstream-Cache-Status' => '$upstream_cache_status'
        },
        # proxy_ignore_client_abort => on Not supported by Puppet
        # END https://github.com/multiplay/lancache/blob/master/lancache/proxy-base

        # BEGIN https://github.com/multiplay/lancache/blob/master/lancache/proxy-cache
        proxy_cache_lock => 'on',
        # proxy_cache_lock_timeout => 1h Not Supported
        proxy_cache_use_stale => 'error timeout invalid_header updating http_500 http_502 http_503 http_504',
        proxy_cache_valid => [
            '200 90d',
            '301 302 0'
        ],
        # proxy_cache_revalidate not supported by Puppet
        proxy_cache_bypass => '$arg_nocache',
        proxy_max_temp_file_size => '40960m',
        # proxy_cache_purge not supported
        # END https://github.com/multiplay/lancache/blob/master/lancache/proxy-cache
    }
}
