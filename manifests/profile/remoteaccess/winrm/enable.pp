#
# Windows Remote Management service. It's like SSH, kinda.
# @TODO File transfers from the NAS dont work when puppet is run over bolt/winrm.
#
class profile::remoteaccess::winrm::enable {

  # This class doesn't do Powershell. Bad things happen. Since we
  # specify that default in role::base this must override it.
  Exec {
    provider => undef
  }

  # https://github.com/thomsonreuters/winrm_ssl
  class { winrm_ssl:
    auth_basic     => true,
    disable_http   => true,
    manage_service => true,
  }

  windows_firewall::exception { 'Allow-WinRM-SSL':
    ensure       => present,
    direction    => 'in',
    action       => 'Allow',
    enabled      => 'yes',
    protocol     => 'TCP',
    local_port   => '5986',
    remote_port  => 'any',
    display_name => 'TurboPuppet Windows Remote Management HTTPS-In',
    description  => 'Allow local subnet to access WinRM SSL port (TCP/5986)',
  }

  # https://support.microsoft.com/en-us/help/951016/description-of-user-account-control-and-remote-restrictions-in-windows
  registry_value { 'LocalAccountTokenFilterPolicy':
    path   => 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\LocalAccountTokenFilterPolicy',
    ensure => present,
    type   => dword,
    data   => 1
  }

  # <frustration, snark, and tiredness>There are good Puppet devs and bad Puppet devs.
  # Unfortuatenly the combination of Windows being Windows and a lack of ordering
  # in the TR-winrm_ssl module, this entire thing took wayyyy toooooo lonnnnnggggg to
  # get working. But after 4 hours of internal screaming, gorramit it works.</>
  Service['winrm'] -> Exec['winrm_create_listener_https'] -> Exec['winrm_delete_http'] ->
  Exec['winrm_set_auth_basic'] -> Exec['winrm_set_maxmemorypershellmb'] -> Exec['winrm_set_maxtimeoutms']

  Class['winrm_ssl'] -> Windows_firewall::Exception['Allow-WinRM-SSL'] -> Registry_value['LocalAccountTokenFilterPolicy']
}