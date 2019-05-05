#
#
#
class profile::time::client::w32time {
    # https://www.top-password.com/blog/enable-or-disable-set-time-zone-automatically-in-windows-10/

    registry_value { 'AutoSetTime':
        ensure => present,
        path   => 'HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters\Type',
        type   => string,
        data   => 'NTP', # or NoSync
        notify => Service['W32Time']
    }

    registry_value { 'AutoSetTimezone':
        ensure => present,
        path   => 'HKLM\SYSTEM\CurrentControlSet\Services\tzautoupdate\Start',
        type   => dword,
        data   => 3, # 4 is disable
        notify => Service['W32Time']
    }

    service { 'W32Time':
        ensure => running,
        enable => true
    }
}
