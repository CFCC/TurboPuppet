#
#
#
class profile::mdns::client {

  case $::kernel {
    'windows': {
      # bonjour had an unreliable package for years (#28) but modern
      # Windows 10 doesn't need any special config to resolve .local
      # mDNS names.
    }
    'Linux': {
      include profile::mdns::client::avahi
    }
    'Darwin': {
      # MacOS includes mDNSResponder by default.
    }
    default: { fail('Unsupported OS') }
  }
}
