#
# Drivers for Beelink devices.
#
class profiles::driver::beelink {
  $local_root = 'C:\CampFitch\opt\Drivers'

  file { 'Beelink Drivers':
    ensure  => directory,
    source  => "${lookup('campfs_uri')}/Drivers/Beelink",
    path    => $local_root,
    recurse => remote,
    purge   => false,
    replace => false,
  }

  # 2026-05-23 AMD broke Beelinks.
  # DPC_WATCHDOG_VIOLATION BSOD and freezing.
  # https://bbs.bee-link.com/d/11127-ser8-r7-8745hs-freezing--dpc_watchdog_violation-0x133/9
  # https://www.reddit.com/r/BeelinkOfficial/comments/1tj29rb/ser8_r7_8745hs_freezing_dpc_watchdog_violation
  #
  # https://community.chocolatey.org/packages/amd-ryzen-chipset/2026.3.9 should be OK
  # https://community.chocolatey.org/packages/amd-ryzen-chipset/2026.5.18 naughty.
  class { 'profiles::driver::cpu::ryzen':
    chipset_package_ensure => '2026.3.9',
  }

  # amdacpbt and amdacpbus[2] were needed in 2025+ to resolve an
  # unknown "Multimedia Controller" device in Device Manager.
  cfcc::driver { 'amdacpbt.inf':
    path    => "${local_root}\\ACPBtAfd\\WT64A\\amdacpbt.inf",
    require => File['Beelink Drivers'],
  }

  if $facts['networking']['hostname'] =~ /(?i:cfccbeelink05)/ {
    cfcc::driver { 'amdacpbus2.inf':
      path    => "${local_root}\\ACPBus2\\WT64A\\amdacpbus2.inf",
      require => File['Beelink Drivers'],
    }
  } else {
    cfcc::driver { 'amdacpbus.inf':
      path    => "${local_root}\\ACPBus\\WT64A\\amdacpbus.inf",
      require => File['Beelink Drivers'],
    }
  }

  # From Audio_9702_UAD_2024_0703_1F660202_2024-07-03_8-20-36.zip.
  # Headphone audio was too quiet without this. We manually applied
  # the contents of the zip file in 2025. Added this driver for 2026.
  cfcc::driver { 'HDXACPWhite.inf':
    path    => "${local_root}\\Codec_9702\\HDXACPWhite.inf",
    require => File['Beelink Drivers'],
  }
}
