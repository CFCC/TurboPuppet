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
            # Articles on The Internet(tm) suggest that deleting %LOCALAPPDATA%\IconCache.db
            # and restarting explorer should fix this. And it did on one of the hosts.
            # Unfortunately it has not on others. So I'm just gonna define it here and be
            # done with it. 'cept for this caveat:
            # Specifying an icon causes this to change every time :(
            shortcut { 'C:/Users/Public/Desktop/PythonTurtle.lnk':
                icon_location => 'C:\Program Files (x86)\PythonTurtle\icon.ico',
                target        => 'C:\Program Files (x86)\PythonTurtle\pythonturtle.exe',
            }
        }
        'Linux': {
            # https://github.com/cool-RR/PythonTurtle
            # These packages were involved somehow (or not?)
            # pip install pathlib2
            # python3-pathlib2
            # python3-wxpython4
            # wxGTK-devel
            # gtk3-devel
            #
            package { 'python3-wxpython4': } ->
            vcsrepo { '/opt/PythonTurtle':
                ensure => present,
                provider => git,
                source => 'https://github.com/cool-RR/PythonTurtle.git',
            } ->
            file { 'TurtleLauncher':
                path   => '/usr/local/bin/python-turtle-launcher.sh',
                source => 'puppet:///modules/cfcc/python/python-turtle-launcher.sh',
                mode   => '0755',
            } ->
            freedesktop::shortcut { 'PythonTurtle':
                exec       => '/usr/local/bin/python-turtle-launcher.sh',
                comment    => 'Python Turtle',
                icon       => "/opt/PythonTurtle/pythonturtle/resources/turtle.png",
                displayname => 'Python Turtle'
            }
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
