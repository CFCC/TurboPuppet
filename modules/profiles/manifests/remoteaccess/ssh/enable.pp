#
#
#
class profile::remoteaccess::ssh::enable {
  case $::kernel {
    'Linux': {
      class { 'ssh': }
    }
    default: {
      fail('Unsupported OS')
    }
  }
}