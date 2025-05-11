#
#
#
class profiles::driver::beelink {
  include profiles::driver::cpu::ryzen

  $driver_root = 'C:/CampFitch/opt/Drivers'

  file { 'Drivers':
    ensure  => 'directory',
    source  => "${lookup('campfs_uri')}\\Drivers",
    path    => $driver_root,
    recurse => 'remote',
    purge   => false,
    replace => false,
  }

  Cfcc::Driver {
    ensure  => present,
    require => File['Drivers'],
  }

  cfcc::driver { 'amdacpbt.inf':
    path   => "${driver_root}/ACPBtAfd/WT64A/amdacpbt.inf",
  }

  cfcc::driver { 'amdacpbus.inf':
    path   => "${driver_root}/ACPBus/WT64A/amdacpbus.inf",
  }
}
