#
# Various built-in Windows apps.
#
class profile::windows::apps {
  $trash_apps = [
    'king.com.CandyCrushSaga',
    'king.com.CandyCrushFriends',
    'Microsoft.Office.OneNote',
    'Microsoft.MicrosoftOfficeHub',
    'Microsoft.SkypeApp',
    'Microsoft.Xbox.TCUI',
    'Microsoft.XboxSpeechToTextOverlay',
    'Microsoft.XboxGameOverlay',
    # 'Microsoft.XboxGameCallableUI', # This one is some baked in feature and can't be removed.
    'Microsoft.XboxIdentityProvider',
    'Microsoft.XboxApp',
    'Microsoft.XboxGamingOverlay',
    'Microsoft.YourPhone',
    'Microsoft.WindowsFeedbackHub',
    'Microsoft.ZuneMusic',
    'Microsoft.ZuneVideo',
    'Microsoft.Messaging',
    'Microsoft.OneConnect',
    'Microsoft.549981C3F5F10', # Cortana. https://www.tomsguide.com/news/how-to-uninstall-cortana
    'Microsoft.WindowsMaps',

  ]
  appxpackage { $trash_apps:
    ensure => 'absent'
  }

  $trash_packages = [
    'Microsoft OneDrive'
  ]

  package { $trash_packages:
    ensure => 'absent'
  }
}