#
# Notepad++ Editor
#
class profile::editor::notepadplusplus {
    $package_name = $::osfamily ? {
        'windows' => 'notepadplusplus',
        default   => fail('Unsupported OS')
    }
    package { $package_name: }
}