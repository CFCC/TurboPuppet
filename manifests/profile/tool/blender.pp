#
# Blender
#
class profile::tool::blender {
  package { 'blender': 
    notify => Exec['CleanupDesktopShortcuts']
  }
}
