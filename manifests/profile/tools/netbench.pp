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
                # @TODO icon_location => '',
                target => "${install_path}/NetBench.jar"
            }
        }
    }

    File['NetBenchInstallDir'] -> File['NetBenchJar']
}
