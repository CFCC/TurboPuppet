#
# Python 3.X Runtime
#
class profile::python::python3 {

    # Install extra required packages
    # We used to have a more normal common package structure
    # but since MacOS requires a noop I broke it out into the
    # individual cases here.
    case $::osfamily {
        'windows': {
            package { 'python3': }
            # Since pip has no resource provider in Windows-land, we
            # have to install packages manually.
            Exec {
                path      => 'C:/Python36/Scripts',
                subscribe => Package['python3']
            }
            exec { 'install pygame':
                command => 'pip.exe install pygame',
                creates => 'C:/Python36/Lib/site-packages/pygame',
            }
            # Note - Python Turtle is included with Python3.
        }
        'RedHat': {
            package { ['python3', 'python3-pip', 'python3-idle']: }
            package { 'pygame':
                ensure   => 'present',
                provider => 'pip3'
            }

            Package['python3']
            -> Package['python3-pip']
            -> Package['pygame']
        }
        'Darwin': {
            # python3 is already included
            package { 'pygame':
                ensure   => 'present',
                provider => 'pip3'
            }
        }
        default: { fail('Unsupported OS') }
    }

}
