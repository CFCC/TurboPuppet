#
# Time client profile.
#
class profiles::time::client (
  $time_servers,
  $time_zone,
) {
  case $facts['os']['family'] {
    'windows': {
      include profiles::time::client::w32time
    }
    'Fedora': {
      include profiles::time::client::chrony
    }
    'Darwin': {
      include profiles::time::client::macos
    }
    default: { fail('Unsupported OS') }
  }
}
