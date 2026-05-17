#
# Drivers for GMKtec devices.
#
class profiles::driver::gmktec {
  $platform_source = "${lookup('campfs_uri')}\\Drivers\\GMKtec"
  $local_root      = 'C:\\CampFitch\\opt\\Drivers'

  file { 'GMKtec Drivers':
    ensure  => directory,
    source  => $platform_source,
    path    => $local_root,
    recurse => remote,
    purge   => false,
    replace => false,
  }

  exec { 'Driver Bundle Installation':
    command => "${local_root}\\AllDriverInstall.cmd",
    unless  => cfcc::psexpr("pnputil.exe /enum-drivers | findstr /i \"mtkbtfilter.inf\""),
    require => File['GMKtec Drivers'],
    returns => [0, 1],
  }

  # Known drivers to install from the bundle.
  # 05_AMD_BT_1.1042.0.527\source\BT\mtkbtfilter.inf
  # 04_AMD_WiFi_5.5.0.3760\source\mtkwecx.inf
  # 09_Camera_11.4.2.629\source\AMDISP\AMDCAMERA\WT64A\amdcamera.inf

  # As of 2025-05 the amd-ryzen-chipset package does not support the AI MAX 395.
  # As of 2026-05 this is still true.
  # include profiles::driver::cpu::ryzen
}
