#
# Tweaks to Explorer.exe
#
class profiles::windows::explorer {
    # We want to preserve the "RunAsAdministrator" bit.
    # https://stackoverflow.com/questions/28997799/how-to-create-a-run-as-administrator-shortcut-using-powershell
    file { 'C:/Users/camper/Desktop/sudo cmd.lnk':
        source => 'puppet:///modules/cfcc/sudocmd.lnk',
    }

    # Disable the UAC warnings
    local_security_policy {
        'User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode':
            ensure         => 'present',
            policy_setting =>
                'MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\ConsentPromptBehaviorAdmin',
            policy_type    => 'Registry Values',
            policy_value   => '4,0',
    }

    local_security_policy { 'User Account Control: Switch to the secure desktop when prompting for elevation':
        ensure         => 'present',
        policy_setting => 'MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\PromptOnSecureDesktop',
        policy_type    => 'Registry Values',
        policy_value   => '4,0',
    }
}