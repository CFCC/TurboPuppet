#
# MIT Scratch
#
class profiles::ide::scratch {
  # Since this is a webapp, we'll simply create a desktop shortcut to make
  # finding it easier.

  case $facts['os']['family'] {
    'windows': {
      # file { 'scratch icon':
      #   path   => 'C:\ProgramData\scratch.ico',
      #   ensure => file,
      #   source => 'https://scratch.mit.edu/favicon.ico',
      # }

      # shortcut { 'C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Scratch.lnk':
      #   icon_location => 'C:\ProgramData\scratch.ico',
      #   require       => [ Class['profiles::browser::chrome'], File['scratch icon'] ],
      #   target        => 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe',
      #   arguments     => 'https://scratch.mit.edu'
      # }
      #
      # Switching to the package
      # https://github.com/CFCC/TurboPuppet/issues/51
      package { 'scratch':
        notify => Exec['CleanupScratchIcon'],
      }

      exec { 'CleanupScratchIcon':
        command     => "Remove-Item 'C:/Users/${lookup('camper_username')}/Desktop/Scratch 3.lnk'",
        refreshonly => true,
        notify      => Exec['Reload Explorer'],
      }
    }
    'Darwin': {
      # the package is broken with a bad checksum on Adobe-AIR
      #package { 'scratch': }
      # Can't just copy a file because it doesnt have the
      # secret Mac attributes.
    }
    # 'Fedora': {
    #   file { 'scratch icon':
    #     path   => '/usr/share/icons/hicolor/32x32/apps/scratch.ico',
    #     source => 'https://scratch.mit.edu/favicon.ico',
    #   }
    #   -> exec { 'convert scratch icon to png':
    #     command => '/usr/bin/convert /usr/share/icons/hicolor/32x32/apps/scratch.ico /usr/share/icons/hicolor/32x32/apps/scratch.png',
    #     # path    => '/usr/share/icons/hicolor/32x32/apps/',
    #     creates => '/usr/share/icons/hicolor/32x32/apps/scratch.png',
    #     notify  => Exec['refresh icon cache'],
    #   }
    #   -> freedesktop::shortcut { 'Scratch':
    #     exec    => 'google-chrome https://scratch.mit.edu',
    #     comment => 'Scratch',
    #     icon    => 'scratch'
    #   }
    #   -> file { "${turbosite::camper_homedir}/Desktop/scratch.desktop":
    #     source => 'file:///usr/local/share/applications/Scratch.desktop',
    #     mode   => '0755',
    #     owner  => $turbosite::camper_username
    #   }

    #   # This only runs if called on
    #   exec { 'refresh icon cache':
    #     refreshonly => true,
    #     command     => '/usr/bin/gtk-update-icon-cache /usr/share/icons/hicolor/'
    #   }
    # }
    default: { fail('Unsupported OS') }
  }
}
