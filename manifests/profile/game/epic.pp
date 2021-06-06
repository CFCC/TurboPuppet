#
# Epic Games Launcher
# This used to do Fortnite, but they do LAN caching these days so who cares!
#
class profile::game::epic {
  package { 'epicgameslauncher':
    notify => Exec['CleanupDesktopShortcuts']
  }
}