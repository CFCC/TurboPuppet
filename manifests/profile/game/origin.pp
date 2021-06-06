#
# EA Origin
# This will yell about LAN caching but it's up to the user to accept.
#
class profile::game::epic {
  package { 'origin':
    notify => Exec['CleanupDesktopShortcuts']
  }
}