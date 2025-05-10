#
#
#
class profiles::driver::cpu::ryzen {
  case $facts['os']['family'] {
    'windows': {
      package { 'amd-ryzen-chipset': }
      package { 'ddu': }
    }
    default: {}
  }
}
