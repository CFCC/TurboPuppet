#
# Minecraft
#
class profile::games::minecraft {
    $package_name = $::osfamily ? {
        'windows' => 'minecraft',
        default   => fail('Unsupported OS')
    }

    package { $package_name: }
}