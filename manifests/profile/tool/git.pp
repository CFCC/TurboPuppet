#
# Git
#
class profile::tool::git {
  package { 'git': }

  case $::operatingsystem {
    'windows': {
      package { 'github-desktop':
        notify => [Exec['kill github-desktop app'], Exec['CleanupGithubDesktopShortcut']]
      }

      # Github Desktop assumes that you instantly want to log in
      # when you install. We don't. Go away.
      exec { 'kill github-desktop app':
        command     => 'Sleep 15; Stop-Process -ProcessName GithubDesktop',
        refreshonly => true
      }

      # Delete the desktop shortcut that it creates. Can't use my common Exec[CleanupDesktopShortcut]
      # because this gets created in the user's desktop dir not the public desktop dir. Refreshonly
      # so that it only applies if the package has changed.
      exec { 'CleanupGithubDesktopShortcut':
        command     => "Remove-Item -Path 'C:/Users/${turbosite::camper_username}/Desktop/Github Desktop.lnk'",
        refreshonly => true
      }
    }
    'Fedora': {
      package { 'gitkraken':
        # require => Yumrepo['_copr_elken-gitkraken']
        source   => 'https://release.gitkraken.com/linux/gitkraken-amd64.rpm',
        provider => 'rpm',
      }

      # There's a thing where it's linked against a filename that doesn't exist.
      # But the library does. Whatevs.....
      file { '/usr/lib64/libcurl-gnutls.so.4':
        ensure  => link,
        target  => '/usr/lib64/libcurl.so.4',
        require => Package['gitkraken']
      }

      file { "${turbosite::camper_homedir}/Desktop/gitkraken.desktop":
        source => 'file:///usr/share/applications/gitkraken.desktop',
        mode   => '0755',
        owner  => $turbosite::camper_username
      }
    }
    'Darwin': {
      # git itself is provided in profile::ide::xcode and
      # is required for brew to function.
      package { 'github': }
    }
    default: {}
  }
}