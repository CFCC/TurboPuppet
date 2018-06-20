#
# Notepad++ Editor
#
class profile::editors::notepadplusplus {
    $package_name = $::osfamily ? {
        'windows' => 'notepadplusplus',
        default   => fail('Unsupported OS')
    }
    package { $package_name: }
}