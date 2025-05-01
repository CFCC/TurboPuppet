#
# Chrony time client profile.
#
class profiles::time::client::chrony {
  package { 'chrony': }

  service { 'chronyd':
    ensure  => running,
    enable  => true,
    require => Package['chrony'],
  }
}
