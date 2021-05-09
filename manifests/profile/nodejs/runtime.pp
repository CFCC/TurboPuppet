#
#
#
class profile::nodejs::runtime {

  case $::operatingsystem {
    'windows': {
      package { 'nodejs-lts': }
      package { 'yarn': }
    }
    default: { fail("Unsupported OS ${operatingsystem}") }
  }
}