#
# Microsft Edge web browser
#
class profiles::browser::edge {
  file { 'EdgeDesktopShortcut':
    ensure => 'absent',
    path   => "C:/Users/${lookup('camper_username')}/Desktop/Microsoft Edge.lnk",
  }
}
