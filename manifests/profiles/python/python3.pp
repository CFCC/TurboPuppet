#
#
#
class profiles::python::python3 {

    $runtime_package_name = $::osfamily ? {
        'windows' => 'python3',
        default   => fail('Unsupported OS')
    }

    package { $runtime_package_name: }

    # Since pip has no resource provider in Windows-land, we
    # have to install packages manually.
    exec { 'install pygame':
        command   => 'pip.exe install pygame',
        path      => 'C:/Python36/Scripts',
        creates   => 'C:/Python36/Lib/site-packages/pygame',
        subscribe => Package[$runtime_package_name]
    }
}