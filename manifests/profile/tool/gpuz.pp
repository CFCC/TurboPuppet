#
# GPU-Z
#
class profile::tool::gpuz {
  package { 'gpu-z':
    notify => Exec['CleanupDesktopShortcuts']
  }
}