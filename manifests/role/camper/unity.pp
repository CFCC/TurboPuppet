#
# For Brendan
#
class role::camper::unity inherits role::base {
    include site::cfcc
    include profile::cfcc::camper
    include profile::access::camper

    Class['site::cfcc'] -> Class['profile::cfcc::camper']
    Class['site::cfcc'] -> Class['profile::access::camper']

    include profile::unity::engine
}