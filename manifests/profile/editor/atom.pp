#
# SublimeText Editor
#
class profile::editor::atom {
    $package_name = $::osfamily ? {
        'windows' => 'atom',
        default   => fail('Unsupported OS')
    }
    package { $package_name: }
}