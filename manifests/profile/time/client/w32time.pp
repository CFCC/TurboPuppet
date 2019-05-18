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
        data   => 4, # 3 is enable
        notify => Service['W32Time']
    }

    registry_value { 'TimeZoneKeyName':
        ensure => present,
        path   => 'HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation',
        type   => string,
        data   => $::turbosite::time_zone,
        notify => Service['W32Time']
    }

    # https://blogs.msdn.microsoft.com/w32time/2008/02/26/configuring-the-time-service-ntpserver-and-specialpollinterval/
    registry_value { 'NtpServer':
        ensure => present,
        path   => 'HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters\NtpServer',
        type   => string,
        data   => join(suffix($::turbosite::time_servers, ',0x9'), ' '),
        notify => Service['W32Time']
    }

    # 20190504 I dont understand why this isn't running by default. Seems that Wumboze
    # had no idea it was ahead and didn't trigger the manual start.
    service { 'W32Time':
        ensure => running,
        enable => true
    }
}
