#
#
#
class profiles::driver::atomman {
  include profiles::driver::gpu::nvidia

  # @TODO dedupe with beelink
  $driver_root = "C:\\CampFitch\\opt\\Drivers"

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

  # cfcc::driver { 'amdacpbt.inf':
  #   path => "${driver_root}\\Beelink\\ACPBtAfd\\WT64A\\amdacpbt.inf",
  # }
}
