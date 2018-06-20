#
# SublimeText Editor
#
class profile::editors::sublime {
    $package_name = $::osfamily ? {
        'Debian' => 'sublime-text',
        default   => fail('Unsupported OS')
    }
    package { $package_name: }
}