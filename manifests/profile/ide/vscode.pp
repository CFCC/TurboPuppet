#
#
#
class profile::ide::vscode {
  package { 'vscode': 
    install_options: [
      '/NoDesktopIcon',
      '/NoQuicklaunchIcon'
    ]
  }
}
