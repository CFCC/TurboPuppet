#
# Testing
#
class role::camper::test {

    include profile::packaging::yum
    include profile::packaging::repositories::fedora

    Class['profile::packaging::yum'] -> Class['profile::packaging::repositories::fedora']
}
