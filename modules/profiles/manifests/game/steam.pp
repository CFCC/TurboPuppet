#
# Steam
#
class profiles::game::steam {
  $package_notify = $facts['os']['family'] ? {
    'windows' => Exec['CleanupDesktopShortcuts'],
    default   => undef,
  }

  $install_options = $facts['os']['family'] ? {
    # This updates so fscking frequently the package maintainers can't keep up leading to
    # occasional failures. Yes this has security implications.
    'windows' => '--ignore-checksums',
    default   => undef,
  }

  package { 'steam':
    notify          => $package_notify,
    install_options => $install_options,
  }

  case $facts['os']['family'] {
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
