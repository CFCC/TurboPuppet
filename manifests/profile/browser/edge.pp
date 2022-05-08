#
# Microsft Edge web browser
#
class profile::browser::edge {
  file { 'EdgeDesktopShortcut':
    ensure => 'absent',
    path   => "C:/Users/${turbosite::camper_username}/Desktop/Microsoft Edge.lnk"
  }
}
