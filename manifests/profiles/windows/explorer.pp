#
# Tweaks to Explorer.exe
#
class profiles::windows::explorer {
    # We want to preserve the "RunAsAdministrator" bit.
    # https://stackoverflow.com/questions/28997799/how-to-create-a-run-as-administrator-shortcut-using-powershell
    file { "C:/Users/${::profiles::site::cfcc::camper_username}/Desktop/sudo cmd.lnk":
        source => 'puppet:///modules/cfcc/sudocmd.lnk',
    }
}