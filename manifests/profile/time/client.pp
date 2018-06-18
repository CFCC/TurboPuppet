#
#
#
class profile::time::client {

    case $::kernel {
        'windows': {
            # https://www.top-password.com/blog/enable-or-disable-set-time-zone-automatically-in-windows-10/

            registry_value { 'AutoSetTime':
                path   => 'HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters\Type',
                type   => string,
                ensure => present,
                data   => 'NTP' # or NoSync
            }

            registry_value { 'AutoSetTimezone':
                path   => 'HKLM\SYSTEM\CurrentControlSet\Services\tzautoupdate\Start',
                type   => dword,
                ensure => present,
                data   => 3, # 4 is disable
            }
        }
        default: { fail('Unsupported OS') }
    }
}