#
# CFCC Server role. This sets up the site for all others.
#
class roles::server inherits roles::base {
  # Tools need to make the system work. DNS, time, etc. While those
  # examples will be applied to all nodes, they require values from the
  # site class (such as the DNS server, time zone, etc).
  # include profiles::time::client

  # The basic blocks of a camper PC. These make a generic functioning computer
  # into something that we can actually use.
  # include profiles::cfcc::server
  # include profiles::access::camper

  # Class['profiles::cfcc::camper'] -> Class['profiles::access::camper']
}
