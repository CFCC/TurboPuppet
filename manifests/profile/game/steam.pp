#
# Steam
#
class profile::game::steam {
  $package_name = $::kernel ? {
    default => 'steam'
  }

  package { $package_name: }

  case $::operatingsystem {
    'windows': {
      # Disable autostart
      hkcu { 'SteamAutostart':
        ensure => absent,
        key    => 'Software\Microsoft\Windows\CurrentVersion\Run',
        value  => 'Steam',
      }
    }
    # Desktop Shortcut
    'Fedora': {
      file { "${turbosite::camper_homedir}/Desktop/steam.desktop":
        source => 'file:///usr/share/applications/steam.desktop',
        mode   => '0755',
        owner  => $turbosite::camper_username
      }
    }
    default: {}
  }
}
