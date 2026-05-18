#
# VideoLAN Media Player VLC
#
class profiles::tool::vlc {
  $package_notify = $facts['kernel'] ? {
    'windows' => Exec['CleanupDesktopShortcuts'],
    default   => undef,
  }

  package { 'vlc':
    notify => $package_notify,
  }
}
