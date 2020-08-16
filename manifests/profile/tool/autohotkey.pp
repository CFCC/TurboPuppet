#
# AutoHotKey
#
class profile::tool::autohotkey {
    package { 'autohotkey': }

    # https://autohotkey.com/board/topic/119664-reloading-script-from-command-prompt/
    exec { 'ReloadAutoHotkey':
      command     => 'AutoHotkey.exe /r',
      refreshonly => true,
    }
}
