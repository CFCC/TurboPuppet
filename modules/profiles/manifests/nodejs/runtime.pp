#
# Node.js runtime
#
class profiles::nodejs::runtime {
  case $facts['os']['family'] {
    'windows': {
      package { 'nodejs-lts': }
      package { 'yarn': }
    }
    'Darwin': {
      warning('profiles::nodejs::runtime has not been implemented on Darwin')
    }
    default: { fail('Unsupported OS') }
  }
}
