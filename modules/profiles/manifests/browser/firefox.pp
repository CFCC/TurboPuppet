#
# Mozilla Firefox web browser
#
class profiles::browser::firefox (
  $package_name,
) {
  $package_notify = $facts['os']['family'] ? {
    'windows' => Exec['CleanupDesktopShortcuts'],
    default   => undef,
  }

  package { $package_name:
    notify => $package_notify,
  }
}
