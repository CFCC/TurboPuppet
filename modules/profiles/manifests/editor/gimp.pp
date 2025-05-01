#
# GNU Image Manipulation Program
#
class profiles::editor::gimp {
  $package_ensure = $facts['os']['family'] ? {
    'windows' => Exec['CleanupDesktopShortcuts'],
    default   => undef,
  }
  package { 'gimp':
    ensure => $package_ensure,
  }
}
