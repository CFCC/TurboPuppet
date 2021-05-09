#
# Various built-in Windows apps. This is probably more than Candy Crush?
#
class profile::windows::apps {
  appxpackage { 'king.com.CandyCrushSaga':
    ensure => 'absent'
  }
}