#
# Introductory stuff
#
class role::camper::intro inherits role::camper {
    include profile::python::turtle
    include profile::ide::scratch
}