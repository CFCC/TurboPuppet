#
# Remote Desktop Protocol - Enable
#
class profiles::remoteaccess::rdp::enable {
  # @TODO this module sucks donkey balls
  class { 'remotedesktop':
    ensure          => present,
    nla             => present,
    manage_firewall => true,
  }
}
