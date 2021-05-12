#
# Steam
#
class profile::game::steam {
  $package_name = $::kernel ? {
    default => 'steam'
  }

  $package_notify = $::kernel ? {
    'windows' => Exec['CleanupDesktopShortcuts'],
    default   => undef,
  }

  package { $package_name:
    notify => $package_notify
  }

  case $::operatingsystem {
    'windows': {
      hkcu { 'DisableSteamAutostart':
        ensure => absent,
        key    => 'Software\Microsoft\Windows\CurrentVersion\Run',
        value  => 'Steam',
      }
    }
    default: {}
  }
}
