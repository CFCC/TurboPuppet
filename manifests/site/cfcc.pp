#
# Site class for CFCC. Contains environment vars and such.
#
class site::cfcc {
  $camper_username = 'camper'
  $camper_uid = 1002
  $puppet_master = 'puppet'
  $time_servers = [
    'pool.ntp.org', # This should be first for Apple-related reasons
    'time.windows.com',
    'time.apple.com'
  ]
  $time_zone = $::kernel ? {
    'windows' => 'Eastern Standard Time',
    default   => 'America/New_York',
  }
  $upstream_dns = [
    '8.8.8.8',
    '8.8.4.4'
  ]
}
