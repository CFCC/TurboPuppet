#
# NetBench - Charlie's network benchmark utility.
#
class profiles::tool::netbenc (
  $jar_source,
) {
  $install_path = $facts['os']['family'] ? {
    'windows' => 'C:/Program Files (x86)/NetBench',
    'Fedora'  => '/opt/netbench',
    'Darwin'  => '/opt/netbench',
    default   => fail('Unsupported OS')
  }

  file { 'NetBenchInstallDir':
    ensure => directory,
    path   => $install_path,
  }

  file { 'NetBenchJar':
    path   => "${install_path}/NetBench.jar",
    source => $jar_source,
  }

  # Shortcut
  case $facts['os']['family'] {
    'windows': {
      shortcut { 'NetBenchShortcut':
        path   => 'C:/ProgramData/Microsoft/Windows/Start Menu/Programs/NetBench.lnk',
        target => "${install_path}/NetBench.jar",
      }
    }
    'Fedora': {
      freedesktop::shortcut { 'NetBench':
        exec    => "java -jar ${install_path}/NetBench.jar",
        comment => 'Network Benchmark Utility',
        icon    => 'network-transmit-receive',
      }
    }
    # @TODO Darwin
    default: {}
  }

  File['NetBenchInstallDir'] -> File['NetBenchJar']
}
