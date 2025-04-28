#
# Setup Yum
#
class profiles::packaging::yum {
  # So.... lets talk about https://forge.puppet.com/puppet/yum
  # It doesn't support Fedora.
  # Good talk.

  case $facts['os']['family'] {
    'Fedora': {
      include profiles::packaging::keys::fedora
      include profiles::packaging::repositories::fedora
      Class['profiles::packaging::keys::fedora'] -> Class['profiles::packaging::repositories::fedora']

      # I hate this tool. Gets in the way of everything.
      # @TODO if we do automated installs this can probably be removed there
      package { 'dnfdragora': ensure => purged }
    }
    default: { fail('Unsupported OS') }
  }
}
