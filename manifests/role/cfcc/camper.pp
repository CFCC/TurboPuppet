#
# CFCC Camper role. This sets up the site for all others.
#
class role::cfcc::camper inherits role::cfcc {
    # The basic blocks of a camper PC. These make a generic functioning computer
    # into something that we can actually use.
    include profile::cfcc::camper
    include profile::access::camper

    Class['profile::cfcc::camper'] -> Class['profile::access::camper']
}
