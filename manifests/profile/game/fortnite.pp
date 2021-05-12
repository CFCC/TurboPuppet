#
# Fortnite bootstrapper
# https://github.com/OpenSourceLAN
#
class profile::game::fortnite {
  package { 'epicgameslauncher':
    notify => Exec['CleanupDesktopShortcuts']
  }

  # See the profile::packages for what the flying saucer here means
  Package <| name == 'rsync' |>

  file { 'fortnite-init':
    path    => 'C:/CampFitch/bin/fortnite-init.ahk',
    source  => 'puppet:///modules/cfcc/fortnite/fortnite-init.ahk',
    require => Class['profile::cfcc::filesystem']
  }
}