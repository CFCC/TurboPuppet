#
# Epic Games Launcher
# This used to do Fortnite, but they do LAN caching these days so who cares!
#
class profiles::game::epic {
  package { 'epicgameslauncher':
    notify => Exec['CleanupDesktopShortcuts'],
  }
}
