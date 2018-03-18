#
#
#
class roles::camper::pyle {
    include profiles::python::python3
    include profiles::python::turtle
    include profiles::ide::pycharm

    Class['profiles::python::python3'] -> Class['profiles::ide::pycharm']
}