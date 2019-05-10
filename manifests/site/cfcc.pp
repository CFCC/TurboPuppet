#
# Site class for CFCC. Contains environment vars and such.
#
class site::cfcc {
    $camper_username = 'camper'
    $puppet_master = 'puppet'
    # $puppet_master = 'seefra.boston.grantcohoe.com'
    $time_servers = [
        'pool.ntp.org',
        'time.windows.com',
        'time.apple.com'
    ]
    $time_zone = $::kernel ? {
        'Darwin' => 'America/New_York'
    }
}
