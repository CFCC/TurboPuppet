#
# This is lifted from https://github.com/steamcache/sniproxy/
#
class profile::lancache::web::sniproxy {
    package { 'sniproxy': }

    file { '/var/log/sniproxy':
        ensure  => 'directory',
        require => Package['sniproxy']
    }

    $upstream_dns = '8.8.8.8'
    $access_log = '/var/log/sniproxy/access.log'
    $error_log = '/var/log/sniproxy/error.log'

    file { '/usr/local/etc/sniproxy.conf':
        content => template('cfcc/sniproxy/sniproxy.conf'),
        notify  => Service['sniproxy']
    }

    service { 'sniproxy':
        ensure  => running,
        enable  => true,
        require => Package['sniproxy']
    }
}