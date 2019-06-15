#
# Generic camper PC. All the things.
#
class role::camper::generic inherits role::camper {
    # Intro
    include profile::ide::scratch

    # Java
    include profile::java::jdk
    include profile::ide::intellij
    Class['profile::java::jdk'] -> Class['profile::ide::intellij']

    # Photostuffs
    include profile::editor::gimp

    # Pyle
    include profile::python::python3
    include profile::python::turtle
    include profile::ide::pycharm
    Class['profile::python::python3'] -> Class['profile::ide::pycharm']

    # Webz
    case $::operatingsystem {
        'windows': {
            include profile::webserver::xampp
        }
        'Darwin': {
            # Web sharing is already a thing
        }
        'Fedora': {
            # @TODO include profile::webserver::apache
        }
        default: {
            fail('Unsupported OS')
        }
    }
    include profile::nodejs::runtime
}
