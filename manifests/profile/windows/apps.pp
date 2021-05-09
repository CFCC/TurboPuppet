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
    'Microsoft.windowscommunicationsapps' # Mail and Calendar

  ]
  appxpackage { $trash_apps:
    ensure => 'absent'
  }

  # @TODO this didn't take the first time. Might have run too quick? Verify.
  $trash_packages = [
    'Microsoft OneDrive'
  ]
  package { $trash_packages:
    ensure => 'absent'
  }
}