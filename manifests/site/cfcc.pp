#
# Site class for CFCC. Contains environment vars and such.
#
class site::cfcc {
    $nas_host = 'TARS'
    $nas_share = 'Public'

    $nas_installers_path = $::kernel ? {
        'windows' => "\\\\${nas_host}\\${nas_share}\\Camp Installers",
        'Linux'  => "//${nas_host}/${nas_share}/Camp\ Installers",
        default   => fail('Unsupported OS')
    }

    $camper_username = 'camper'

    $puppet_master = 'puppet.grantcohoe.com'

    # @TODO This was loaded from the profile::time::client but role::base
    # does not load the site class.
    # $time_zone = 'Eastern Standard Time'
}