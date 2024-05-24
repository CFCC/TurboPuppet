#
# Blender
#
class profile::tool::blender {
  package { 'blender': 
    notify => $::kernel ? {
      'windows' => Notify['CleanupBlenderShortcut'],
      default   => undef,
    }
  }

  exec { 'CleanupBlenderShortcut':
    command     => "Remove-Item -Path 'C:\\Users\\${turbosite::camper_username}\\Desktop\\Blender\*.lnk'",
    refreshonly => true,
  }
}
