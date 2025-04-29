#
# CFCC Camper role. This sets up the site for all others.
#
class roles::camper inherits roles::base {
  # Tools need to make the system work. DNS, time, etc. While those
  # examples will be applied to all nodes, they require values from the
  # site class (such as the DNS server, time zone, etc).
  include profiles::time::client
  # include profiles::storage::mountpoints

  # # The basic blocks of a camper PC. These make a generic functioning computer
  # # into something that we can actually use.
  include profiles::cfcc::camper
  # include profiles::access::camper

  # Class['profiles::time::client'] -> Class['profiles::cfcc::camper']
  # Class['profiles::storage::mountpoints'] -> Class['profiles::cfcc::camper']
  # Class['profiles::cfcc::camper'] -> Class['profiles::access::camper']
}
