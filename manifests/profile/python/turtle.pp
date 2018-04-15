#
# The baby version of Python Turtle
# The PythonTurtle library is provided with Python3.
# Also of note - PythonTurtle != Turtle. The latter is an HTTP library.
#
class profile::python::turtle {
    # The package name is obnoxious.
    # https://puppet.com/docs/puppet/5.0/resources_package_windows.html#packages-that-include-version-info-in-their-displayname
    package {'PythonTurtle 0.1':
        provider => windows,
        source   => "${::site::cfcc::nas_installers_path}\pythonturtle-0.1.2009.8.2.1-unattended.msi",
    }
}