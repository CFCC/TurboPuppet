#
#
#
class profile::power::alwayson {
  case $::kernel {
    'windows': { include profile::power::alwayson::windows }
    'Linux': { include profile::power::alwayson::linux }
    default: { fail("Unsuported OS") }
  }
}