#
# Install the GMKtec driver bundle.
#
# @param driver_root The local directory where drivers were copied to.
#
class profiles::driver::gmktec (
  String $driver_root = $profiles::driver::base::driver_root,
) inherits profiles::driver::base {
  # As of 2025-05 the amd-ryzen-chipset package does not support the AI MAX 395.
  include profiles::driver::cpu::ryzen

  # @TODO this is kinda janky. AMD will likely update a new package soon.
  # But need a better way to instrument this kind of driver install anyway.
  # exec { 'Driver Bundle Installation':
  #   command     => "${driver_root}\\GMKtec\\AllDriverInstall.cmd",
  #   refreshonly => true,
  #   require     => File['Camp Drivers'],
  #   subscribe   => File['Camp Drivers'],
  #   returns     => [0, 1],
  # }
}
