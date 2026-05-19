#
# GNU Image Manipulation Program
#
class profiles::editor::gimp {
  package { 'gimp': }

  if $facts['os']['family'] == 'windows' {
    exec { 'CleanupGimpDesktopShortcut':
      command     => "Remove-Item -Path 'C:\\Users\\${lookup('camper_username')}\\Desktop\\GIMP*.lnk'",
      refreshonly => true,
      subscribe   => Package['gimp'],
    }
  }
}
