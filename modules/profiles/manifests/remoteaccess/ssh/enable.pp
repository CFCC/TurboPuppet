#
# Enable SSH access.
#
class profiles::remoteaccess::ssh::enable {
  case $facts['kernel'] {
    'Linux': {
      class { 'ssh': }
    }
    default: {
      fail('Unsupported OS')
    }
  }
}
