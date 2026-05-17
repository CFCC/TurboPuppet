#
# Enable SSH access.
#
class profiles::remoteaccess::ssh::enable {
  case $facts['kernel'] {
    'Linux': {
      class { 'ssh': }
    }
    'Darwin': {
      warning('profiles::remoteaccess::ssh::enable has not been implemented on Darwin')
    }
    default: {
      fail('Unsupported OS')
    }
  }
}
