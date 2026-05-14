#
# EA Origin
# This will yell about LAN caching but it's up to the user to accept.
#
class profiles::game::origin {
  $package_notify = $facts['os']['family'] ? {
    'windows' => [Exec['CleanupDesktopShortcuts'], Exec['kill ea desktop app']],
    default   => Exec['CleanupDesktopShortcuts'],
  }

  $install_options = $facts['os']['family'] ? {
    'windows' => '--ignore-checksums',
    default   => undef,
  }

  # 2025 they replaced Origin with EA App.
  package { 'ea-app':
    notify          => $package_notify,
    install_options => $install_options,
  }

  case $facts['os']['family'] {
    'windows': {
      cfcc::hkcu { 'DisableEADesktopAutostart':
        ensure => absent,
        key    => 'Software\Microsoft\Windows\CurrentVersion\Run',
        value  => 'EADM',
      }

      exec { 'kill ea desktop app':
        command     => 'Sleep 15; Stop-Process -ProcessName EADesktop',
        refreshonly => true,
      }
    }
    default: {}
  }
}
