#
# Install Rosetta 2 on Apple Silicon Macs.
#
class profiles::tool::rosetta {
  exec { 'InstallRosetta':
    command => '/usr/sbin/softwareupdate --install-rosetta --agree-to-license',
    unless  => '/usr/sbin/pkgutil --pkg-info=com.apple.pkg.RosettaUpdateAuto',
    path    => ['/usr/sbin', '/usr/bin', '/bin'],
  }
}
