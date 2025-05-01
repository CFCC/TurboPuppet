#
# GPU-Z
#
class profiles::tool::gpuz {
  package { 'gpu-z':
    notify => Exec['CleanupDesktopShortcuts'],
  }
}
