#
#
#
class profile::ide::intellij {
  # Lock down the version we actually want.
  # Starting with 2022.1[.1] the Choco package dropped the last version number.
  # This may toast Linux and require some shenanigans.
  $intellij_version = '2022.1'

  $package_name = $::operatingsystem ? {
    'windows' => 'intellijidea-community',
    'Fedora'  => 'intellij-idea-community',
    'Darwin'  => 'intellij-idea-ce',
    default   => fail('Unsupported OS')
  }

  $package_notify = $::kernel ? {
    'windows' => Exec['CleanupDesktopShortcuts'],
    default   => undef,
  }

  # Like Pycharm, Brew doesnt support ensure => version.
  package { $package_name:
    ensure => $::operatingsystem ? {
      'Darwin' => present,
      default  => $intellij_version
    },
    notify => $package_notify
  }

  # @TODO maybe figure out a way to auto-detect the installed JDK so that we don't have to set it manually.
}
