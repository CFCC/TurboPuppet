#
# Various built-in Windows apps. This is probably more than Candy Crush?
#
class profile::windows::apps {
  $trash_apps = [
    'king.com.CandyCrushSaga',
    'king.com.CandyCrushFriends',
  ]
  appxpackage { $trash_apps:
    ensure => 'absent'
  }
}