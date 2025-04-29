#
# CFCC Camper role. This sets up the site for all others.
#
class roles::camper inherits roles::base {
  # Tools need to make the system work. DNS, time, etc. While those
  # examples will be applied to all nodes, they require values from the
  # site class (such as the DNS server, time zone, etc).
  # include profile::time::client
  # include profile::storage::mountpoints

  # # The basic blocks of a camper PC. These make a generic functioning computer
  # # into something that we can actually use.
  include profile::cfcc::camper
  # include profile::access::camper

  # Class['profile::time::client'] -> Class['profile::cfcc::camper']
  # Class['profile::storage::mountpoints'] -> Class['profile::cfcc::camper']
  # Class['profile::cfcc::camper'] -> Class['profile::access::camper']
}
