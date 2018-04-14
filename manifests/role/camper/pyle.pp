#
# Pyle Power!
#
class role::camper::pyle inherits role::camper::base {
    include profile::python::python3
    include profile::python::turtle
    include profile::ide::pycharm

    Class['profile::python::python3'] -> Class['profile::ide::pycharm']
}