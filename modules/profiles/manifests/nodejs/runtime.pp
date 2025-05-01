#
# Node.js runtime
#
class profiles::nodejs::runtime {
  case $facts['os']['family'] {
    'windows': {
      package { 'nodejs-lts': }
      package { 'yarn': }
    }
    default: { fail('Unsupported OS') }
  }
}
