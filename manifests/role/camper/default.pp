#
# Default Node. This lays down a generic PC without any topic
# specific tools.
#
class role::camper::default inherits role::base {
    notify {'CFCC Default Node': }

    include site::cfcc
    include profile::cfcc::camper
    include profile::access::camper

    Class['site::cfcc'] -> Class['profile::cfcc::camper']
    Class['site::cfcc'] -> Class['profile::access::camper']
}