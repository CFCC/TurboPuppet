#
# Base role for all camper machines. This will make Puppet work
# and include the big three (base, cfcc::camper, access). Very little else
# should go in here.
#
class roles::camper::windows {
    # This is where we specify defaults that automatically apply to ALL
    # package{} resources in child classes. These can be overridden
    # as needed.
    #
    # Windows requires the provider to be explicitly stated.
    Package {
        provider => chocolatey,
        ensure   => present,
    }

    include profiles::base
    include profiles::cfcc::camper
    include profiles::access::camper
    include profiles::windows::base

    Class['profiles::base'] -> Class['profiles::cfcc::camper']
    Class['profiles::base'] -> Class['profiles::access::camper']
}