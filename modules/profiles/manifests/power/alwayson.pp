#
# Always-on power management.
#
class profiles::power::alwayson {
  case $facts['os']['family'] {
    'windows': { include profiles::power::alwayson::windows }
    'Linux': { include profiles::power::alwayson::linux }
    'Darwin': {
      warning('profiles::power::alwayson has not been implemented on Darwin')
    }
    default: { fail('Unsuported OS') }
  }
}
