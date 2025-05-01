#
#
#
class profile::driver::cpu::ryzen {

  case $::operatingsystem {
    'windows': {
      package { 'amd-ryzen-chipset': }
      package { 'ddu': }
    }
    default: {}
  }

}
