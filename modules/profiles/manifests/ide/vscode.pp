#
# Visual Studio Code
#
class profiles::ide::vscode {
  package { 'vscode':
    # install_options gets passed as a single string option to the command, which means it tries to
    # install a package called "--params \"/NoDesktopIcon /NoQuicklaunchIcon\"" which is effin stoopid.
    # install_options => [
    #   '--params "/NoDesktopIcon /NoQuicklaunchIcon"'
    # ],
    notify => Exec['CleanupDesktopShortcuts'],
  }

  package { ['vscode-python', 'vscode-java']:
    require => Package['vscode'],
  }
}
