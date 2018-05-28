#
# Steam
#
class profile::games::steam {
    $package_name = $::kernel ? {
        'windows' => 'steam',
        'Linux'   => 'steam',
        default   => fail('Unsupported OS')
    }

    # @TODO On Debian for Steam:
    # echo steam steam/question select "I AGREE" | sudo debconf-set-selections
    # echo steam steam/license note '' | sudo debconf-set-selections

    package { $package_name: }
}