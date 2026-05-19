#
# Always-on power management.
#
class profiles::power::alwayson {
  case $facts['os']['family'] {
    'windows': { include profiles::power::alwayson::windows }
    'Linux': { include profiles::power::alwayson::linux }
    'Darwin': { include profiles::power::alwayson::darwin }
    default: { fail('Unsuported OS') }
  }
}
