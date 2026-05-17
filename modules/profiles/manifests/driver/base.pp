#
# Base class for all driver profiles.
#
# @param driver_root The local directory where drivers are to be copied to.
# @param drivers_source UNC path to the Drivers tree on campfs (see data/common.yaml).
#
class profiles::driver::base (
  String $driver_root,
  String $drivers_source,
) {
  file { $driver_root:
    ensure => 'directory',
  }
}
