#
# Pyle Power!
#
class role::camper::pyle inherits role::base {
    include site::cfcc
    include profile::cfcc::camper
    include profile::access::camper

    Class['site::cfcc'] -> Class['profile::cfcc::camper']
    Class['site::cfcc'] -> Class['profile::access::camper']

    include profile::python::python3
    include profile::python::turtle
    include profile::ide::pycharm

    Class['profile::python::python3'] -> Class['profile::ide::pycharm']
}
