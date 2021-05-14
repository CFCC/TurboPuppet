#
# VNC - Enable
#
class profile::remoteaccess::vnc::enable {
  case $::operatingsystem {
    'windows': {
      package { 'tightvnc': }
    }
    default: { fail('Unsupported OS') }
  }
}