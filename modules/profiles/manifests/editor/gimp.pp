#
# GNU Image Manipulation Program
#
class profiles::editor::gimp {
  package { 'gimp': }

  exec { 'CleanupGimpDesktopShortcut':
    command     => "Remove-Item -Path 'C:\\Users\\${lookup('camper_username')}\\Desktop\\GIMP*.lnk'",
    refreshonly => true,
    subscribe   => Package['gimp'],
  }
}
