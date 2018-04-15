#
#
#
class profile::python::python3 {

    $runtime_package_name = $::osfamily ? {
        'windows' => 'python3',
        default   => fail('Unsupported OS')
    }

    package { $runtime_package_name: }

    # Install extra required packages
    case $::osfamily {
        'windows': {
            # Since pip has no resource provider in Windows-land, we
            # have to install packages manually.
            Exec {
                path      => 'C:/Python36/Scripts',
                subscribe => Package[$runtime_package_name]
            }
            exec { 'install pygame':
                command => 'pip.exe install pygame',
                creates => 'C:/Python36/Lib/site-packages/pygame',
            }
            # Note - Python Turtle is included with Python3.
        }
        default: { }
    }

}
