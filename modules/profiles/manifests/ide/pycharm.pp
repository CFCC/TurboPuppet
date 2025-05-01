#
# JetBrains PyCharm IDE
#
class profiles::ide::pycharm (
  $package_name,
  $package_ensure,
) {
  $package_notify = $facts['os']['family'] ? {
    'windows' => Exec['CleanupDesktopShortcuts'],
    default   => undef,
  }

  package { $package_name:
    # Brew doesnt support ensuring specific versions. This
    # isn't ideal but we can at least deal with it.
    ensure => $package_ensure,
    notify => $package_notify,
  }

  # OS-specific stuff
  # Desktop Shortcut
  # case $::operatingsystem {
  #   'Fedora': {
  #     file { "${turbosite::camper_homedir}/Desktop/pycharm-community.desktop":
  #       source => 'file:///usr/share/applications/pycharm-community.desktop',
  #       mode   => '0755',
  #       owner  => $turbosite::camper_username
  #     }
  #   }
  #   default: {}
  # }
}
