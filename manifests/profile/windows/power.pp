#
# Power and sleep settings
#
class profile::windows::power {
    # Due to a bug with the Zotacs/NVIDIA chips, the system infinitely hangs
    # when the display goes to sleep. This seems to be around the HDMI audio capabilities
    # of the cards. No driver workaround has been found to work reliably.
    $display_sleep_interval = 0

    # This maps to the "High Performance" power plan
    $guid_power_plan = '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'
    $guid_subgroup_display = '7516b95f-f776-4464-8c53-06167f40cc99'
    $guid_setting_displaysleep = '3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e'

    # Some references:
    # https://facility9.com/2015/07/controlling-the-windows-power-plan-with-powershell/

    exec { 'SetPowerPlan':
        command => "powercfg -setactive ${guid_power_plan}",
        onlyif  => psexpr("((powercfg -getactivescheme).split()[3] -ne '${guid_power_plan}')")
    }

    $cmd_get_displaysleep_setting = "powercfg /Q ${guid_power_plan} ${guid_subgroup_display} ${guid_setting_displaysleep} | Select-String 'Current AC Power' | select -exp 'line'"
    exec { 'SetDisplaySleep':
        command => "powercfg /SETACVALUEINDEX ${guid_power_plan} ${guid_subgroup_display} ${guid_setting_displaysleep} ${display_sleep_interval}",
        onlyif  => psexpr("([int](${cmd_get_displaysleep_setting}).split()[-1] -ne ${display_sleep_interval})")
    }

    Exec['SetPowerPlan'] -> Exec['SetDisplaySleep']
}