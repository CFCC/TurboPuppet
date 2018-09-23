#
#
#
class profile::time::client::chrony {
    package { 'chrony': }

    service { 'chronyd':
        enable => true,
        ensure => running,
    }

    Package['chrony'] -> Service['chronyd']
}
