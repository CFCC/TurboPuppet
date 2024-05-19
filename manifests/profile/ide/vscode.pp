#
#
#
class profile::ide::vscode {
  package { 'vscode':
    install_options => [
      '--params "/NoDesktopIcon /NoQuicklaunchIcon"'
    ]
  }
}
