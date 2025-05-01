#
# VideoLAN Media Player VLC
#
class profiles::tool::vlc {
  package { 'vlc':
    notify => Exec['CleanupDesktopShortcuts'],
  }
}
