#
# CFCC Server role. This sets up the site for all others.
#
class role::cfcc::server inherits role::cfcc {
    # The basic blocks of a camper PC. These make a generic functioning computer
    # into something that we can actually use.
    # include profile::cfcc::camper
    # include profile::access::camper
    # @TODO repos will go here someday

    # Class['profile::cfcc::camper'] -> Class['profile::access::camper']
}
