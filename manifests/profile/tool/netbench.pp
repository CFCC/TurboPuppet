#
# NetBench - Charlie's network benchmark utility.
#
class profile::tool::netbench {
  $install_path = $::operatingsystem ? {
    'windows' => 'C:/Program Files (x86)/NetBench',
    'Fedora'  => '/opt/netbench',
    'Darwin'  => '/opt/netbench',
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
  case $::operatingsystem {
    'windows': {
      shortcut { 'NetBenchShortcut':
        path   => 'C:/ProgramData/Microsoft/Windows/Start Menu/Programs/NetBench.lnk',
        target => "${install_path}/NetBench.jar"
      }
    }
    'Fedora': {
      freedesktop::shortcut { 'NetBench':
        exec    => "java -jar ${install_path}/NetBench.jar",
        comment => 'Network Benchmark Utility',
        icon    => 'network-transmit-receive'
      }
    }
    # @TODO Darwin
  }

  File['NetBenchInstallDir'] -> File['NetBenchJar']
}
