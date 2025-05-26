#
# EA Origin
# This will yell about LAN caching but it's up to the user to accept.
#
class profiles::game::origin {
  # 2025 they replaced Origin with EA App.
  package { 'ea-app':
    notify => Exec['CleanupDesktopShortcuts'],
  }
}
