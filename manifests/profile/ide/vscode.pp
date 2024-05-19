#
#
#
class profile::ide::vscode {
  package { 'vscode':
    install_options => [
      '--params "/NoDesktopIcon /NoQuicklaunchIcon"'
    ]
  }

  package { ['vscode-python', 'vscode-java']: 
    require => Package['vscode']
  }
}
