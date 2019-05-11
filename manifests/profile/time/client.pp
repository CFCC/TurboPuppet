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
        'Darwin': {
            include profile::time::client::macos
        }
        'FreeBSD': {
            # These are NAS jails and get their time from the host.
        }
        default: { fail('Unsupported OS') }
    }
}
