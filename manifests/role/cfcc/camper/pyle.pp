#
# Pyle Power!
#
class role::cfcc::camper::pyle inherits role::cfcc::camper {
    include profile::python::python3
    include profile::python::turtle
    include profile::ide::pycharm

    Class['profile::python::python3'] -> Class['profile::ide::pycharm']
}
