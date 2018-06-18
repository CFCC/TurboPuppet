#
#
#
class profile::access::autologin::enable {

    case $::osfamily {
        'windows': {
            # https://gallery.technet.microsoft.com/scriptcenter/Set-AutoLogon-and-execute-19ec3879

            $reg_path = 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'

            registry_key { 'WinLogon':
                path   => $reg_path,
                ensure => present,
            }

            # Default for resources
            Registry_value {
                ensure => present
            }

            registry_value { 'AutoAdminLogon':
                path   => "${reg_path}\AutoAdminLogon",
                type   => string,
                data   => '1',
            }

            registry_value { 'DefaultUsername':
                path => "${reg_path}\DefaultUsername",
                type => string,
                data => $::site::cfcc::camper_username,
            }

            registry_value { 'DefaultPassword':
                path => "${reg_path}\DefaultPassword",
                type => string,
                data => $::site::cfcc::camper_username,
            }

            registry_value { 'AutoLogonCount':
                path => "${reg_path}\AutoLogonCount",
                type => dword,
                data => 1
            }

            Registry_key['WinLogon'] -> Registry_value['AutoAdminLogon'] ->
            Registry_value['DefaultUsername'] -> Registry_value['DefaultPassword']
        }
        default: { }
    }

}