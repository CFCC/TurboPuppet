#
# Install the GMKtec driver bundle.
#
# @param driver_root The local directory where drivers were copied to.
#
class profiles::driver::gmktec (
  String $driver_root = $profiles::driver::base::driver_root,
) inherits profiles::driver::base {
  file { 'GMKtec Drivers':
    ensure  => 'directory',
    source  => "${drivers_source}\\GMKtec",
    path    => "${driver_root}\\GMKtec",
    recurse => 'remote',
    purge   => false,
    replace => false,
  }

  # As of 2025-05 the amd-ryzen-chipset package does not support the AI MAX 395.
  include profiles::driver::cpu::ryzen

  # @TODO this is kinda janky. AMD will likely update a new package soon.
  # But need a better way to instrument this kind of driver install anyway.
  # exec { 'Driver Bundle Installation':
  #   command     => "${driver_root}\\GMKtec\\AllDriverInstall.cmd",
  #   refreshonly => true,
  #   require     => File['GMKtec Drivers'],
  #   subscribe   => File['GMKtec Drivers'],
  #   returns     => [0, 1],
  # }
}
