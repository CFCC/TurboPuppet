#
# Drivers for Beelink devices.
#
# amdacpbt and amdacpbus[2] were needed in 2025 and 2026 to resolve an
# unknown "Multimedia Controller" device in Device Manager.
#
class profiles::driver::beelink (
  String $driver_root = $profiles::driver::base::driver_root,
) inherits profiles::driver::base {
  include profiles::driver::cpu::ryzen

  cfcc::driver { 'amdacpbt.inf':
    path => "${driver_root}\\Beelink\\ACPBtAfd\\WT64A\\amdacpbt.inf",
  }

  if $facts['networking']['hostname'] =~ /(?i:cfccbeelink05)/ {
    cfcc::driver { 'amdacpbus2.inf':
      path => "${driver_root}\\Beelink\\ACPBus2\\WT64A\\amdacpbus2.inf",
    }
  } else {
    cfcc::driver { 'amdacpbus.inf':
      path => "${driver_root}\\Beelink\\ACPBus\\WT64A\\amdacpbus.inf",
    }
  }

  # From Audio_9702_UAD_2024_0703_1F660202_2024-07-03_8-20-36.zip.
  # Headphone audio was too quiet without this.
  cfcc::driver { 'HDXACPWhite.inf':
    path => "${driver_root}\\Beelink\\Codec_9702\\HDXACPWhite.inf",
   }
}
