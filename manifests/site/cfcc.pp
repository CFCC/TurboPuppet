#
# Site class for CFCC. Contains environment vars and such.
#
class site::cfcc {
    $camper_username = 'camper'
    $puppet_master = 'seefra.boston.grantcohoe.com'
    $time_servers = [
        'time.windows.com',
        'pool.ntp.org'
    ]
}
