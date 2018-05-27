#
# Notepad++ Editor
#
class profile::tools::notepadplusplus {
    $package_name = $::osfamily ? {
        'windows' => 'notepadplusplus',
        default   => fail('Unsupported OS')
    }
    package { $package_name: }
}