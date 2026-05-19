#
# Visual Studio Code
#
class profiles::ide::vscode {
  $vscode_package_title          = lookup('profiles::ide::vscode::vscode_package_title', String, 'first', 'vscode')
  $darwin_brew_install_options   = lookup('profiles::ide::vscode::darwin_brew_install_options', Optional[Array[String]], 'first', undef)

  $package_notify = $facts['kernel'] ? {
    'windows' => Exec['CleanupDesktopShortcuts'],
    default   => undef,
  }

  $brew_install_opts = $facts['os']['family'] ? {
    'Darwin' => $darwin_brew_install_options,
    default  => undef,
  }

  package { $vscode_package_title:
    notify          => $package_notify,
    install_options => $brew_install_opts,
  }

  if $facts['os']['family'] == 'windows' {
    package { ['vscode-python', 'vscode-java']:
      require => Package[$vscode_package_title],
    }
  }

  if $facts['os']['family'] == 'Darwin' {
    # Default: Homebrew cask symlink (no spaces). Override if nonstandard.
    $code_cli               = lookup('profiles::ide::vscode::code_cli', String, 'first', '/usr/local/bin/code')
    $darwin_extension_ids = lookup('profiles::ide::vscode::darwin_extension_ids', Array[String], 'first', ['ms-python.python', 'vscjava.vscode-java-pack'])

    $darwin_extension_ids.each |String $extension_id| {
      exec { "vscode extension ${extension_id}":
        command => "${code_cli} --install-extension ${extension_id}",
        unless  => "/bin/bash -c \"${code_cli} --list-extensions | /usr/bin/grep -qx '${extension_id}'\"",
        path    => ['/bin', '/usr/bin', '/usr/local/bin'],
        require => Package[$vscode_package_title],
      }
    }
  }
}
