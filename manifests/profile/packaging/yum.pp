#
# Setup Yum
#
class profile::packaging::yum {
    # So.... lets talk about https://forge.puppet.com/puppet/yum
    # It doesn't support Fedora.
    # Good talk.

    case $::operatingsystem {
        'Fedora': { include profile::packaging::repositories::fedora }
        default: { fail('Unsupported OS') }
    }
}
