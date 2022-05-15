#
# Class defining all mountpoints.
#
class profile::storage::mountpoints {
  Mount {
    ensure => 'mounted'
  }
  case $::kernel {
    'windows': {
      # This is what we'd do if the module supported complex options like remount at login.
      # Unfortunately it does not so we have to be sketchy about it.
      exec { 'MountDeployShare':
        command => "net use F: \\\\${turbosite::nas}\\Depoy /persistent:yes /user:${::turbosite::camper_username} ${::turbosite::camper_username}",
        unless  => "net use F:"
      }

      mount { 'F:':
        ensure  => 'mounted',
        device  => "//${turbosite::nas}/Deploy",
        require => Exec['MountDeployShare']
      }
    }
    'Linux': {}
  }
}
