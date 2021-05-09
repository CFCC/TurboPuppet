#
#
#
class profile::time::client {

  case $::operatingsystem {
    'windows': {
      include profile::time::client::w32time
    }
    'Fedora': {
      include profile::time::client::chrony
    }
    'Darwin': {
      include profile::time::client::macos
    }
    default: { fail('Unsupported OS') }
  }
}
