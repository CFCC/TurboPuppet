#
# Install the GMKtec driver bundle.
#
class profiles::driver::gmktec {
  $platform_source = "${lookup('campfs_uri')}\\Drivers\\GMKtec"

  # @TODO this is kinda janky. AMD will likely update a new package soon.
  # But need a better way to instrument this kind of driver install anyway.
  exec { 'Driver Bundle Installation':
    command     => "${platform_source}\\AllDriverInstall.cmd",
    # refreshonly => true,
    returns     => [0, 1],
    cwd         => $platform_source,
  }

  # 05_AMD_BT_1.1042.0.527\source\BT\mtkbtfilter.inf
  # 04_AMD_WiFi_5.5.0.3760\source\mtkwecx.inf


  # As of 2025-05 the amd-ryzen-chipset package does not support the AI MAX 395.
  # This is still true as of 2026-05.
  # include profiles::driver::cpu::ryzen
}
