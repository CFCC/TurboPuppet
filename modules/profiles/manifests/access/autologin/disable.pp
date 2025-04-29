#
# Disable automatically logging into the camper account on boot.
#
class profiles::access::autologin::disable {
  case $facts['os']['family'] {
    'windows': {
      # https://gallery.technet.microsoft.com/scriptcenter/Set-AutoLogon-and-execute-19ec3879

      $reg_path = 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'

      # Can't drop the whole key. There are things in there that are needed.
      registry_key { 'WinLogon':
        ensure => present,
        path   => $reg_path,
      }

      # Default for resources
      Registry_value {
        ensure => absent,
      }

      registry_value { 'AutoAdminLogon':
        path => "${reg_path}\\AutoAdminLogon",
      }

      registry_value { 'DefaultUsername':
        path => "${reg_path}\\DefaultUsername",
      }

      registry_value { 'DefaultPassword':
        path => "${reg_path}\\DefaultPassword",
      }

      registry_value { 'AutoLogonCount':
        path => "${reg_path}\\AutoLogonCount",
      }

      Registry_key['WinLogon']
      -> Registry_value['AutoAdminLogon']
      -> Registry_value['DefaultUsername']
      -> Registry_value['DefaultPassword']
    }
    default: {}
  }
}
