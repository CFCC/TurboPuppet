#
#
#
class profile::browser::firefox {

  $package_name = $::kernel ? {
    'windows' => 'Firefox',
    'Linux'   => 'firefox',
    'Darwin'  => 'firefox',
    default   => fail('Unsupported OS')
  }

  $package_notify = $::kernel ? {
    'windows' => Exec['CleanupDesktopShortcuts'],
    default   => undef,
  }

  package { $package_name:
    notify => $package_notify
  }

}
