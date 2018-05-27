#
# MobaXterm
#
class profile::tools::mobaxterm {
    $package_name = $::osfamily ? {
        'windows' => 'mobaxterm',
        default   => fail('Unsupported OS')
    }
    package { $package_name: }
}