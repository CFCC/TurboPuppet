#
# NetBench - Charlie's network benchmark utility.
#
class profile::tools::netbench {
    $install_path = $::osfamily ? {
        'windows' => 'C:/Program Files (x86)/NetBench',
        default   => fail('Unsupported OS')
    }

    file { 'NetBenchInstallDir':
        path   => $install_path,
        ensure => directory
    }

    file { 'NetBenchJar':
        path   => "${install_path}/NetBench.jar",
        source => "${turbosite::nas_installers_path}\\NetBench.jar"
    }

    # Shortcut
    case $::osfamily {
        'windows': {
            shortcut { 'NetBenchShortcut':
                path   => 'C:/ProgramData/Microsoft/Windows/Start Menu/Programs/NetBench.lnk',
                # icon_location => 'C:\ProgramData\scratch.ico',
                target => "${install_path}/NetBench.jar"
            }
        }
    }

    File['NetBenchInstallDir'] -> File['NetBenchJar']

    # Scheduled runs cost $$$ :(
}