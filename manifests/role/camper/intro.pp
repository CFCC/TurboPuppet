#
# Introductory stuff
#
class role::camper::intro inherits role::base {
    include site::cfcc
    include profile::cfcc::camper
    include profile::access::camper

    Class['site::cfcc'] -> Class['profile::cfcc::camper']
    Class['site::cfcc'] -> Class['profile::access::camper']

    include profile::python::turtle
    include profile::ide::alice
    include profile::ide::scratch
}