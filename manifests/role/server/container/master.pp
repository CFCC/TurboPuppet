#
#
#
class role::server::container::master inherits role::base {
    include site::cfcc
    # include profile::cfcc::camper
    # include profile::access::camper

    # Class['site::cfcc'] -> Class['profile::cfcc::camper']
    # Class['site::cfcc'] -> Class['profile::access::camper']
    include profile::docker::host
    include profile::portainer::local

    Class['profile::docker::host'] -> Class['profile::portainer::local']
}