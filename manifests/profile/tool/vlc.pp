#
# VideoLAN Media Player VLC
#
class profile::tool::vlc {
  package { 'vlc':
    notify => Exec['CleanupDesktopShortcuts']
  }
}