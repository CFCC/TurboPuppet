#
# Power and sleep settings
# Some references:
# https://facility9.com/2015/07/controlling-the-windows-power-plan-with-powershell/
#
class profile::power::alwayson::windows {
  # This maps to the "High Performance" power plan
  $guid_power_plan = '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'

  exec { 'SetPowerPlan':
    command => "powercfg -setactive ${guid_power_plan}",
    onlyif  => psexpr("(powercfg -getactivescheme).split()[3] -ne '${guid_power_plan}'")
  }

  # Make the display never sleep
  # Due to a bug with the Zotacs/NVIDIA chips, the system infinitely hangs
  # when the display goes to sleep. This seems to be around the HDMI audio capabilities
  # of the cards. No driver workaround has been found to work reliably.
  $guid_subgroup_display = '7516b95f-f776-4464-8c53-06167f40cc99'
  $guid_setting_displaysleep = '3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e'
  $display_sleep_interval = 0

  $cmd_get_displaysleep_setting = "powercfg /Q ${guid_power_plan} ${guid_subgroup_display} ${guid_setting_displaysleep}
     | Select-String 'Current AC Power' | select -exp 'line'"
  exec { 'SetDisplaySleep':
    command => "powercfg /SETACVALUEINDEX ${guid_power_plan} ${guid_subgroup_display} ${guid_setting_displaysleep} ${display_sleep_interval}
      ",
    onlyif  => psexpr("[int](${cmd_get_displaysleep_setting}).split()[-1] -ne ${display_sleep_interval}")
  }

  # Make the system never sleep
  $guid_subgroup_sleep = '238c9fa8-0aad-41ed-83f4-97be242c8f20'
  $guid_setting_sleepafter = '29f6c1db-86da-48c5-9fdb-f2b67b1f44da'
  $system_sleep_interval = 0

  $cmd_get_systemsleep_setting = "powercfg /Q ${guid_power_plan} ${guid_subgroup_sleep} ${guid_setting_sleepafter}
     | Select-String 'Current AC Power' | select -exp 'line'"

  exec { 'SetSystemSleep':
    command => "powercfg /SETACVALUEINDEX ${guid_power_plan} ${guid_subgroup_sleep} ${guid_setting_sleepafter} ${system_sleep_interval}",
    onlyif  => psexpr("[int](${cmd_get_systemsleep_setting}).split()[-1] -ne ${system_sleep_interval}")
  }

  # Also disable hibernation
  # http://www.powertheshell.com/test-path-ignores-hidden-files/
  # NOTE - powercfg -h operations will fail in VMs. But then again, you should
  # never have to this disable there since Hibernation should never be able to
  # get enabled. Hopefully....
  exec { 'DisableHibernation':
    command => "powercfg -h off",
    onlyif  => psexpr("[System.IO.Directory]::EnumerateFiles('C:\\') -contains ('C:\\hiberfil.sys')")
  }

  Exec['SetPowerPlan'] -> Exec['SetDisplaySleep'] -> Exec['SetSystemSleep'] -> Exec['DisableHibernation']
}

