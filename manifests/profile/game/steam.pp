#
# Steam
#
class profile::game::steam {
    $package_name = $::kernel ? {
        default   => 'steam'
    }

    package { $package_name: }
}