#
# CFCC Camper role. This sets up the site for all others.
#
class role::camper inherits role::base {
  # Define the site parameters of the installation. To allow for profiles
  # to reference a generic site container (ie, turbosite::camper_username vs
  # site::cfcc::camper_username), we need to redefine those vars into the generic
  # class container. Include the site::whoever class then define them into
  # a turbosite.
  include site::cfcc

  class { 'turbosite':
    camper_username => $site::cfcc::camper_username,
    puppet_master   => $site::cfcc::puppet_master,
    time_servers    => $site::cfcc::time_servers,
    time_zone       => $site::cfcc::time_zone,
    upstream_dns    => $site::cfcc::upstream_dns,
    camper_uid      => $site::cfcc::camper_uid,
    nas             => $site::cfcc::nas,
  }

  # Tools need to make the system work. DNS, time, etc. While those
  # examples will be applied to all nodes, they require values from the
  # site class (such as the DNS server, time zone, etc).
  include profile::time::client
  include profile::storage::mountpoints

  # The basic blocks of a camper PC. These make a generic functioning computer
  # into something that we can actually use.
  include profile::cfcc::camper
  include profile::access::camper

  Class['profile::time::client'] -> Class['profile::cfcc::camper']
  Class['profile::storage::mountpoints'] -> Class['profile::cfcc::camper']
  Class['profile::cfcc::camper'] -> Class['profile::access::camper']
}
