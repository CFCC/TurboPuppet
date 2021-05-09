#
# Microsft Edge web browser
# This profile has the distinction of being the only one to REMOVE rather than INSTALL.
#
class profile::browser::edge {
  appxpackage { 'Microsoft.MicrosoftEdge':
    ensure => 'absent',
  }
}
