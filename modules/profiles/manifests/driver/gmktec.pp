#
# Install the GMKtec driver bundle.
#
class profiles::driver::gmktec {
  $platform_source = "${lookup('campfs_uri')}\\Drivers\\GMKtec"

  # As of 2025-05 the amd-ryzen-chipset package does not support the AI MAX 395.
  include profiles::driver::cpu::ryzen
}
