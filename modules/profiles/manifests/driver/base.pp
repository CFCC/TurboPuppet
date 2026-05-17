#
# Base class for all driver profiles.
#
# @param driver_root The local directory where drivers are to be copied to.
#
class profiles::driver::base (
  String $driver_root,
) {
  # file { 'Camp Drivers':
  #   ensure  => 'directory',
  #   source  => "${lookup('campfs_uri')}\\Drivers",
  #   path    => $driver_root,
  #   recurse => 'remote',
  #   purge   => false,
  #   replace => false,
  # }

  Cfcc::Driver {
    ensure  => present,
    require => File['Camp Drivers'],
  }
}
