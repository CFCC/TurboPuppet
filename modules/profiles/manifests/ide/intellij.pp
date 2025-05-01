#
#
#
class profiles::ide::intellij (
  $package_name,
  $package_ensure,
) {
  $package_notify = $facts['os']['family'] ? {
    'windows' => Exec['CleanupDesktopShortcuts'],
    default   => undef,
  }

  # Like Pycharm, Brew doesnt support ensure => version.
  package { $package_name:
    ensure => $package_ensure,
    notify => $package_notify,
  }

  # @TODO maybe figure out a way to auto-detect the installed JDK so that we don't have to set it manually.
}
