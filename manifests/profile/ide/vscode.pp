#
# Visual Studio Code
#
class profile::ide::vscode {
  package { 'vscode':
    install_options => [
      '--params "/NoDesktopIcon /NoQuicklaunchIcon"'
    ],
    notify => Exec['CleanupDesktopShortcuts'],
  }

  package { ['vscode-python', 'vscode-java']: 
    require => Package['vscode']
  }
}
