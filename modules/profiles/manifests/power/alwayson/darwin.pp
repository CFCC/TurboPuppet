#
# Always-on power settings for macOS (AC + battery).
#
class profiles::power::alwayson::darwin {
  exec { 'DarwinPmsetDisableSleep':
    command => '/usr/bin/pmset -a sleep 0 displaysleep 0 disksleep 0',
    path    => ['/usr/bin', '/bin', '/usr/sbin', '/sbin'],
  }
}
