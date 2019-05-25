#
# The baby version of Python Turtle
# The PythonTurtle library is provided with Python3.
# Also of note - PythonTurtle != Turtle. The latter is an HTTP library.
#
class profile::python::turtle {
    case $::kernel {
        'windows': {
            # The package name is obnoxious.
            # https://puppet.com/docs/puppet/5.0/resources_package_windows.html#packages-that-include-version-info-in-their-displayname
            # I used to be able to do package { : source => puppet:///campfs } but apparently
            # that doesnt work anymore?
            file { 'PythonTurtleInstaller':
                path   => 'C:/CampFitch/usr/share/PyTurtle.msi',
                source => 'puppet:///campfs/pythonturtle-0.1.2009.8.2.1-unattended.msi',
            } ->
            package { 'PythonTurtle 0.1':
                provider => windows,
                source   => 'C:/CampFitch/usr/share/PyTurtle.msi',
            } ->
            # Specifying an icon causes this to change every time :(
            shortcut { 'C:/Users/Public/Desktop/PythonTurtle.lnk':
                icon_location => 'C:\Program Files (x86)\PythonTurtle\icon.ico',
                target        => 'C:\Program Files (x86)\PythonTurtle\pythonturtle.exe',
            }
        }
        'Linux': {
            # There is no EZ-Turtle for Linux
        }
        'Darwin': {
            $local_dmg_path = '/var/tmp/PythonTurtle.Mac.installer.dmg'
            file { 'turtle-dmg':
                source => 'puppet:///campfs/PythonTurtle.Mac.installer.dmg',
                path   => $local_dmg_path
            } ->
            package { 'PythonTurtle':
                ensure   => present,
                provider => appdmg,
                source   => $local_dmg_path
            }
        }
        default: {}
    }

}
