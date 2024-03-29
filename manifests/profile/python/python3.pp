#
# Python 3.X Runtime
#
class profile::python::python3 {

  # Install extra required packages
  # We used to have a more normal common package structure
  # but since MacOS requires a noop I broke it out into the
  # individual cases here.
  case $::operatingsystem {
    'windows': {
      package { 'python3':
        ensure => '3.10.4'
      }
      # pip3 works on Windows but isn't in the path until you restart
      # your shell. Also for some reason Powershell doesn't really
      # work until you reboot. I subbed in a command => 'foobarlolz'
      # and it still ran successfully. What's up with that eh?
      exec { 'InstallPygame':
        path      => 'C:/Python310/Scripts',
        command   => 'pip3.exe install pygame',
        subscribe => Package['python3'],
        creates   => 'C:/Python310/Lib/site-packages/pygame',
        provider  => 'windows'
      }

      # Note - Python Turtle is included with Python3.
    }
    'Fedora': {
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
