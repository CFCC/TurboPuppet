#
# Drivers for Minisforum AtomMan devices.
#
class profiles::driver::atomman {
  include profiles::driver::gpu::nvidia

  $local_root = 'C:\CampFitch\opt\Drivers'

  file { 'AtomMan Drivers':
    ensure  => directory,
    source  => "${lookup('campfs_uri')}/Drivers/AtomMan",
    path    => $local_root,
    recurse => remote,
    purge   => false,
    replace => false,
  }

  Cfcc::Driver {
    require => File['AtomMan Drivers'],
  }

  cfcc::driver { 'RtsPer.inf':
    path => "${local_root}\\14-Realtek_Cardreader\\Drivers\\RtsPer.inf",
  }

  cfcc::driver { 'TbtHostController.inf':
    path => "${local_root}\\7-Intel_Thunderbolt\\Drivers\\TbtHostController.inf",
  }

  cfcc::driver { 'gna.inf':
    path => "${local_root}\\6-Intel_GNA\\gna.inf",
  }

  cfcc::driver { 'ipf_cpu.inf':
    path => "${local_root}\\3-Intel_DTT_IPF\\Drivers\\ipf_cpu.inf",
  }

  cfcc::driver { 'ipf_ef_ext.inf':
    path => "${local_root}\\3-Intel_DTT_IPF\\Drivers\\ipf_ef_ext.inf",
  }

  cfcc::driver { 'ipf_ef_sw.inf':
    path => "${local_root}\\3-Intel_DTT_IPF\\Drivers\\ipf_ef_sw.inf",
  }

  cfcc::driver { 'ipf_acpi.inf':
    path => "${local_root}\\3-Intel_DTT_IPF\\Drivers\\ipf_acpi.inf",
  }

  cfcc::driver { 'dtt_sw.inf':
    path => "${local_root}\\3-Intel_DTT_IPF\\Drivers\\dtt_sw.inf",
  }

  cfcc::driver { 'dtt_ext.inf':
    path => "${local_root}\\3-Intel_DTT_IPF\\Drivers\\dtt_ext.inf",
  }

  cfcc::driver { 'RaptorLakePCH-SSystem.inf':
    path => "${local_root}\\1-Intel_Chipset\\DriverFiles\\production\\Windows10-x64\\RaptorLakePCH-SSystem.inf",
  }

  cfcc::driver { 'RaptorLakePCH-SSystemLPSS.inf':
    path => "${local_root}\\1-Intel_Chipset\\DriverFiles\\production\\Windows10-x64\\RaptorLakePCH-SSystemLPSS.inf",
  }

  # Maybe?
  cfcc::driver { 'RaptorLakeSystem.inf':
    path => "${local_root}\\1-Intel_Chipset\\DriverFiles\\production\\Windows10-x64\\RaptorLakeSystem.inf",
  }

  cfcc::driver { 'HidEventFilter.inf':
    path => "${local_root}\\4-Intel_HIDEventFilterDriver\\x64\\HidEventFilter.inf",
  }

  cfcc::driver { 'iaLPSS2_GPIO2_ADL.inf':
    path => "${local_root}\\2-Intel_SerialIO\\production\\Windows10-x64\\0\\Drivers\\WU\\iaLPSS2_GPIO2_ADL.inf",
  }

  cfcc::driver { 'IntcAudioBus.inf':
    path => "${local_root}\\8-Intel_SST\\Drivers\\IntcAudioBus.inf",
  }

  cfcc::driver { 'IntcDMicExt_Senary.inf':
    path => "${local_root}\\11-Senary_Audio\\SenaryAPO\\IntcDMicExt_Senary.inf",
  }

  cfcc::driver { 'cisstrtU-base.inf':
    path => "${local_root}\\11-Senary_Audio\\cisstrtU-base.inf",
  }

}
