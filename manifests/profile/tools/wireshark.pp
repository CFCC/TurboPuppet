#
# Wireshark
#
class profile::tools::wireshark {
    # FC28 wireshark has both qt and gtk. The wireshark metapackage
    # provides qt and cli.
    $package_name = $::operatingsystem ? {
        'Fedora' => 'wireshark',
        'windows' => 'wireshark',
        default => fail('Unsupported OS')
    }

    # Some platforms require extra things to make it work
    case $::osfamily {
        'windows': {
            package { 'winpcap':
                before => [ Package[$pacakge_name] ]
            }
        }
    }

    package { $package_name: }
}
