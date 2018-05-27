#
# Bonjour mDNS Service
#
class profile::tools::bonjour {
    # 20180527 - v2.0.2 from 2016 is amazingly the "latest"
    package { 'bonjour': }

    service { 'Bonjour Service':
        ensure => 'running',
        enable => 'true',
    }

    Package['bonjour'] -> Service['Bonjour Service']
}