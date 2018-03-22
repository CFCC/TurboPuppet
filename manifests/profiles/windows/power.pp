#
# Power and sleep settings
#
class profiles::windows::power {
    # Set power plan

    # Set display sleep to none

    # Set system sleep to 30 mins

    # `powercfg /query` lists all settings
    # HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\${SUBGROUP_GUID}\${SETTING_GUID}\DefaultPowerSchemeValues\${POWER_SCHEME_GUID}\AcSettingIndex

    # Default plan:
    #HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\User\Default\PowerSchemes
    # 381b4222-f694-41f0-9685-ff5bb260df2e Balanaced
    # 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c high perf

    # #HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes\SCHEME_GUID\SUVGROUP_GUID\SETTING_GUID

    # https://forge.puppet.com/puppetlabs/registry


    $power_scheme_guid = '381b4222-f694-41f0-9685-ff5bb260df2e'
    $display_subgroup_guid = '7516b95f-f776-4464-8c53-06167f40cc99'
    $display_sleep_guid = '3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e'

    registry_value { 'DisplaySleepTime':
        path => "HKLM\\SYSTEM\\CurrentControlSet\\Control\\Power\\User\\PowerSchemes\\${power_scheme_guid}\\${
            display_subgroup_guid}\\${display_sleep_guid}\ACSettingIndex",
        type => 'dword',
        data => 0
    }

    reg_acl { 'DisplaySleepTime':
        target      => "HKLM\\SYSTEM\\CurrentControlSet\\Control\\Power\\User\\PowerSchemes\\${power_scheme_guid}\\${
            display_subgroup_guid}\\${display_sleep_guid}",
        owner       => 'BUILTIN\Administrators',
        permissions => [
            { 'RegistryRights' => 'FullControl', 'IdentityReference' => 'BUILTIN\Administrators' }
        ]
    }

    Reg_acl['DisplaySleepTime'] -> Registry_value['DisplaySleepTime']

    # Administrators need rights to HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes

    # setacl.exe -on "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes" -ot reg -actn setowner -ownr "n:Administrators"
    # setacl.exe -on "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\User\PowerShemes" -ot reg -actn ace -ace "n:Administrators;p:full" -rec yes

    # setacl.exe -on "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes\381b4222-f694-41f0-9685-ff5bb260df2e\7516b95f-f776-4464-8c53-06167f40cc99" -ot reg -actn setowner -ownr "n:Administrators" -rec yes
    # https://forge.puppet.com/ipcrm/registry_acl/0.0.1
}