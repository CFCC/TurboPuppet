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
            package { 'pygame':
                ensure   => 'present',
                provider => 'pip3'
            }
            # Note - Python Turtle is included with Python3.
            Package['python3']
            -> Package['pygame']
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
