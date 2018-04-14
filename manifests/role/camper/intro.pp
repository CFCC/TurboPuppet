#
#
#
class role::camper::intro inherits role::camper::base {
    include profile::python::turtle
    include profile::ide::alice
    include profile::ide::scratch
}