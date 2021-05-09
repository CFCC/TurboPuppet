#
# Setup Yum
#
class profile::packaging::yum {
  # So.... lets talk about https://forge.puppet.com/puppet/yum
  # It doesn't support Fedora.
  # Good talk.

  case $::operatingsystem {
    'Fedora': {
      include profile::packaging::keys::fedora
      include profile::packaging::repositories::fedora
      Class['profile::packaging::keys::fedora'] -> Class['profile::packaging::repositories::fedora']

      # I hate this tool. Gets in the way of everything.
      # @TODO if we do automated installs this can probably be removed there
      package { 'dnfdragora': ensure => purged }
    }
    default: { fail('Unsupported OS') }
  }
}