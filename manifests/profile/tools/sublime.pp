#
# SublimeText Editor
#
class profile::tools::sublime {
    $package_name = $::osfamily ? {
        'Debian' => 'sublime-text',
        default   => fail('Unsupported OS')
    }
    package { $package_name: }
}