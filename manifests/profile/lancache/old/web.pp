#
#
#
class profile::lancache::webold {

    # These dirs are not managed by the nginx module
    $proxy_cache_directories = [
        '/mnt/LanCache/cache/',
        '/mnt/LanCache/cache/installs',
        '/mnt/LanCache/cache/other'
    ]
    file { $proxy_cache_directories:
        ensure => directory,
        owner  => $::nginx::params::daemon_user,
        group  => $::nginx::params::daemon_group,
    }

    file { '/var/log/lancache':
        ensure => directory,
        owner  => $::nginx::params::daemon_user,
        group  => $::nginx::params::daemon_group,
    }

    # Log formatting comes from https://github.com/multiplay/lancache/blob/master/lancache/logging
    class { '::nginx':
        proxy_temp_path => '/mnt/LanCache/cache/tmp',
        daemon_group    => 'lancache-rw',
        log_format      => {
            'main' =>
            '$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" "$upstream_cache_status" "$host" "$http_range" "$request_time" "$upstream_response_time"'
        },
        require         => [ File['/var/log/lancache'], File[$proxy_cache_directories] ]
    }

    $proxy_cache_paths = {
        installs => {
            path     => '/mnt/LanCache/cache/installs',
            levels   => '2:2',
            size     => '4096m', # num of files?
            inactive => '120d',
            max_size => '5767168m',
            extras   => [
                'loader_files=1000',
                'loader_sleep=50ms',
                'loader_threshold=300ms'
            ]
        },
        other    => {
            path     => '/mnt/LanCache/cache/other',
            levels   => '2:2',
            size     => '100m',
            inactive => '72h',
            max_size => '10240m'
        }
    }

    file { 'proxy-cache.conf':
        path    => '/usr/local/etc/nginx/conf.d/proxy-cache.conf',
        content => template('cfcc/nginx/proxy-cache.conf.erb'),
        notify  => Service['nginx']
    }


}
