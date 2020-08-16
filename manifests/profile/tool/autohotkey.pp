#
# AutoHotKey
#
class profile::tool::autohotkey {
    package { 'autohotkey': }

    exec { 'ReloadAutoHotkey':
      command     => 'AutoHotkey.exe /r',
      refreshonly => true,
    }
}
