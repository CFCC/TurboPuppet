#
#
#
class profile::time::client {

    case $::osfamily {
        'windows': {
            include profile::time::client::w32time
        }
        'RedHat': {
            include profile::time::client::chrony
        }
        'Darwin': {}
        default: { fail('Unsupported OS') }
    }
}
