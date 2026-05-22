#
# Always-on power settings for macOS (AC + battery).
#
class profiles::power::alwayson::darwin {
  exec { 'DarwinPmsetDisableSleep':
    command => '/usr/bin/pmset -a sleep 0 displaysleep 0 disksleep 0',
    path    => ['/usr/bin', '/bin', '/usr/sbin', '/sbin'],
    onlyif  => '/usr/bin/pmset -g | /usr/bin/grep -qE "^\s+(sleep|displaysleep|disksleep)\s+[1-9]"',
  }
}
