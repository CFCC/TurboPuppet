#
# Blender
#
class profile::tool::blender {
  package { 'blender': }

  file { 'BlenderDesktopShortcut':
    ensure => 'absent',
    path   => "C:/Users/${turbosite::camper_username}/Desktop/Blender 3.5.lnk",
    require => Package['blender']
  }
}
