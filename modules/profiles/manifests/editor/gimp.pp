#
# GNU Image Manipulation Program
#
class profiles::editor::gimp {
  package { 'gimp': }

  exec { 'CleanupGimpDesktopShortcut':
    command     => "Remove-Item -Path 'C:\\Users\\${lookup('camper_username')}\\Desktop\\GIMP 3.0.2-1.lnk'",
    refreshonly => true,
    subscribe   => Package['gimp'],
  }
}
