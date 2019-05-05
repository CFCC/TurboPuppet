#
# 7zip
#
class profile::tool::sevenzip {
    $package_name = $::operatingsystem ? {
        'Fedora'  => 'p7zip',
        'windows' => '7zip',
        default   => fail('Unsupported OS')
    }

    package { $package_name: }
}
