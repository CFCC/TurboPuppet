#
# GNU Image Manipulation Program
#
class profiles::editor::gimp {
  $package_notify = $facts['os']['family'] ? {
    'windows' => Exec['CleanupDesktopShortcuts'],
    default   => undef,
  }
  package { 'gimp':
    notify => $package_notify,
  }
}
