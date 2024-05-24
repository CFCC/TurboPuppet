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

  $install_options = $::kernel ? {
    # This updates so fscking frequently the package maintainers can't keep up leading to
    # occasional failures. Yes this has security implications.
    'windows' => '--ignore-checksums',
    default   => undef,
  }

  package { $package_name:
    notify          => $package_notify,
    install_options => $install_options,
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
