#
# Class defining all mountpoints.
#
class profile::storage::mountpoints {
  Mount {
    ensure => 'mounted'
  }
# Disabling this because nothing works as we hope.
#  case $::kernel {
#    'windows': {
      # If the module let use define the persistent parameter (and other things like that) then we wouldn't
      # need this bonus Exec here. Unfortunately it does not support these things which makes life difficult.
      # The exec would be fine on its own but I'd rather have a true Mount resource available to reference
      # elsewhere in the catalog (such as in the chocolatey configuration). By making the exec a require
      # and since its persistent this should always exist and as such the mount is really a no-op.
      #
      # A side effect of any Windows mounts here is that they are mounted as the administrative user
      # and thus don't show up in Explorer for the camper user. You can see them if you do manual shell
      # commands like dir/ls.
#      exec { 'MountDeployShare':
#        command => "net use F: \\\\${turbosite::nas}\\Deploy /persistent:yes /user:${::turbosite::camper_username} ${::turbosite::camper_username}",
#        unless  => "net use F:"
#      }
#
#      mount { 'F:':
#        ensure  => 'mounted',
#        device  => "//${turbosite::nas}/Deploy",
#        require => Exec['MountDeployShare']
#      }
#    }
#    'Linux': {}
#  }
}
