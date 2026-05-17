#
# Drivers for Beelink devices.
#
class profiles::driver::beelink (
  String $driver_root = $profiles::driver::base::driver_root,
) inherits profiles::driver::base {
  $platform_source = "${drivers_source}\\Beelink"
  $platform_root   = "${driver_root}\\Beelink"

  file { 'Beelink Drivers':
    ensure  => 'directory',
    source  => $platform_source,
    path    => $platform_root,
    recurse => 'remote',
    purge   => false,
    replace => false,
  }

  Cfcc::Driver {
    ensure  => present,
    require => File['Beelink Drivers'],
  }

  include profiles::driver::cpu::ryzen

  # amdacpbt and amdacpbus[2] were needed in 2025+ to resolve an
  # unknown "Multimedia Controller" device in Device Manager.
  cfcc::driver { 'amdacpbt.inf':
    path => "${driver_root}\\ACPBtAfd\\WT64A\\amdacpbt.inf",
  }

  if $facts['networking']['hostname'] =~ /(?i:cfccbeelink05)/ {
    cfcc::driver { 'amdacpbus2.inf':
      path => "${driver_root}\\ACPBus2\\WT64A\\amdacpbus2.inf",
    }
  } else {
    cfcc::driver { 'amdacpbus.inf':
      path => "${driver_root}\\ACPBus\\WT64A\\amdacpbus.inf",
    }
  }

  # From Audio_9702_UAD_2024_0703_1F660202_2024-07-03_8-20-36.zip.
  # Headphone audio was too quiet without this. We manually applied
  # the contents of the zip file in 2025. Added this driver for 2026.
  cfcc::driver { 'HDXACPWhite.inf':
    path => "${driver_root}\\Codec_9702\\HDXACPWhite.inf",
   }
}
