#
# Camper user access profile.
# @TODO sudo class. It overrides /etc/sudoers for at least Mac.
#
class profiles::access::camper {
  $username = lookup('camper_username')
  # In other places we key off of the $::kernel fact. That doesn't
  # work for us here since different distros have different groups.
  case $facts['os']['family'] {
    'windows': {
      include profiles::access::uac::disable
      # $user_groups = ['BUILTIN\Administrators', "BUILTIN\Remote Management Users"]
      $user_groups = ['BUILTIN\Administrators']
    }
    'Fedora': {
      # camper : camper adm cdrom sudo dip plugdev lpadmin sambashare
      $user_groups = ['wheel']

      sudo::conf { 'camper':
        priority => 10,
        content  => "${username}
           ALL=(ALL) NOPASSWD: ALL\nDefaults    secure_path = /usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/puppetlabs/bin",
      }
    }
    'Darwin': {
      # User is usually already in the admin group
      $user_groups = ['admin']
      sudo::conf { 'camper':
        priority => 10,
        content  => "${username} ALL=(ALL) NOPASSWD: ALL",
      }
    }
    default: {
      fail('platform is unsupported')
    }
  }

  user { 'camper':
    ensure => present,
    name   => $username,
    groups => $user_groups,
    before => Class['profiles::access::autologin::enable'],
  }

  include profiles::access::autologin::enable
  include profiles::access::usericon
}
