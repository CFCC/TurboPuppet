#
# Install the GMKtec driver bundle.
#
# @param driver_root The local directory where drivers were copied to.
#
class profiles::driver::gmktec (
  String $driver_root = $profiles::driver::base::driver_root,
  String $drivers_source = $profiles::driver::base::drivers_source,
) inherits profiles::driver::base {
  $platform_source = "${drivers_source}\\GMKtec"
  $platform_root   = "${driver_root}\\GMKtec"

  file { 'GMKtec Drivers':
    ensure  => 'directory',
    source  => $platform_source,
    path    => $platform_root,
    recurse => 'remote',
    purge   => false,
    replace => false,
  }

  # As of 2025-05 the amd-ryzen-chipset package does not support the AI MAX 395.
  include profiles::driver::cpu::ryzen

  # @TODO this is kinda janky. AMD will likely update a new package soon.
  # But need a better way to instrument this kind of driver install anyway.
  # exec { 'Driver Bundle Installation':
  #   command     => "${platform_root}\\AllDriverInstall.cmd",
  #   refreshonly => true,
  #   require     => File['GMKtec Drivers'],
  #   subscribe   => File['GMKtec Drivers'],
  #   returns     => [0, 1],
  # }
}
