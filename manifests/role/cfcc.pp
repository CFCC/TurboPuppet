#
# Site-specific role that sets defaults across all nodes within the site.
#
class role::cfcc inherits role::base {
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
        upstream_dns    => $site::cfcc::upstream_dns
    }

    # Tools need to make the system work. DNS, time, etc. While those
    # examples will be applied to all nodes, they require values from the
    # site class (such as the DNS server, time zone, etc).
    include profile::time::client
    # @TODO package repo setup should go here someday
}