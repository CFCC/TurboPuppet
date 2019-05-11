#
# Introductory stuff
#
class role::cfcc::camper::intro inherits role::cfcc::camper {
    include profile::python::turtle
    include profile::ide::scratch
}