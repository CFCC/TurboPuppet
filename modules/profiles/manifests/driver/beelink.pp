#
#
#
class profiles::driver::beelink inherits profiles::driver::base {
  include profiles::driver::cpu::ryzen

  # $driver_root = "C:\\CampFitch\\opt\\Drivers"

  # file { 'Drivers':
  #   ensure  => 'directory',
  #   source  => "${lookup('campfs_uri')}\\Drivers",
  #   path    => $driver_root,
  #   recurse => 'remote',
  #   purge   => false,
  #   replace => false,
  # }

  # Cfcc::Driver {
  #   ensure  => present,
  #   require => File['Drivers'],
  # }

  # cfcc::driver { 'amdacpbt.inf':
  #   path => "${driver_root}\\Beelink\\ACPBtAfd\\WT64A\\amdacpbt.inf",
  # }

  # if $facts['networking']['hostname'] =~ /(?i:cfccbeelink05)/ {
  #   cfcc::driver { 'amdacpbus2.inf':
  #     path => "${driver_root}\\Beelink\\ACPBus2\\WT64A\\amdacpbus2.inf",
  #   }
  # } else {
  #   cfcc::driver { 'amdacpbus.inf':
  #     path => "${driver_root}\\Beelink\\ACPBus\\WT64A\\amdacpbus.inf",
  #   }
  # }
}
