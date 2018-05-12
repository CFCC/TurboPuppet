#
# Windows Update settings.
#
class profile::windows::update {
    # Set active hours
    registry_value { 'HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings\ActiveHoursStart':
        ensure => present,
        type   => dword,
        data   => 8 # 8AM
    }

    registry_value { 'HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings\ActiveHoursEnd':
        ensure => present,
        type   => dword,
        data   => 20 # 8PM
    }
}