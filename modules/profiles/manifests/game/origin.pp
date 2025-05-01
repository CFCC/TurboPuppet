#
# EA Origin
# This will yell about LAN caching but it's up to the user to accept.
#
class profiles::game::origin {
  package { 'origin':
    notify => Exec['CleanupDesktopShortcuts'],
  }
}
