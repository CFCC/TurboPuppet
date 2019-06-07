#
#
#
class profile::mdns::client {

    case $::kernel {
        'windows': {
            include profile::mdns::client::bonjour
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
