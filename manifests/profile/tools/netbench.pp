#
# NetBench - Charlie's network benchmark utility.
#
class profile::tools::netbench {
    $install_path = $::osfamily ? {
        'windows' => 'C:/Program Files (x86)/NetBench',
        'RedHat'  => '/opt/netbench',
        default   => fail('Unsupported OS')
    }

    file { 'NetBenchInstallDir':
        path   => $install_path,
        ensure => directory,
    }

    file { 'NetBenchJar':
        path   => "${install_path}/NetBench.jar",
        source => 'puppet:///campfs/NetBench.jar',
    }

    # Shortcut
    case $::osfamily {
        'windows': {
            shortcut { 'NetBenchShortcut':
                path   => 'C:/ProgramData/Microsoft/Windows/Start Menu/Programs/NetBench.lnk',
                target => "${install_path}/NetBench.jar"
            }
        }
        'RedHat': {
            freedesktop::shortcut { 'NetBench':
                exec    => "${install_path}/NetBench.jar",
                comment => 'Network Benchmark Utility',
                icon    => 'network-transmit-receive'
            }
        }
    }

    File['NetBenchInstallDir'] -> File['NetBenchJar']
}
