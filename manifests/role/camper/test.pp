#
# Testing
#
class role::camper::test {

    include profile::packaging::yum
    # include profiles::desktop::cinnamon

    # Class['profile::packaging::yum'] -> Class['profile::packaging::repositories::fedora']
}
