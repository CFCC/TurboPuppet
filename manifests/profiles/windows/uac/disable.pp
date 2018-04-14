#
# User Account Control - Disable
#
class profile::windows::uac::disable {
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