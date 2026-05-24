#
#
#
class profiles::driver::cpu::ryzen (
  String $chipset_package_ensure = 'present',
) {
  case $facts['os']['family'] {
    'windows': {
      package { 'amd-ryzen-chipset': 
        ensure => $chipset_package_ensure,
      }
      package { 'ddu': }
    }
    default: {}
  }
}
