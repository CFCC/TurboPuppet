#
# JetBrains PyCharm IDE
#
class profile::ide::pycharm {
  # Lock down the version of Pycharm we actually want.
  # NOTE - version updates with Choco work great. They purge the old one.
  # If you installed Pycharm manually then you can end up with multiple
  # versions.
  $pycharm_version = '2021.1.1'

  $package_name = $::operatingsystem ? {
    'windows' => 'PyCharm-community',
    'Fedora'  => 'pycharm-community',
    'Darwin'  => 'pycharm-ce',
    default   => fail('Unsupported OS')
  }

  package { $package_name:
    # Brew doesnt support ensuring specific versions. This
    # isn't ideal but we can at least deal with it.
    ensure => $::operatingsystem ? {
      'Darwin' => 'present',
      default  => $pycharm_version
    }
  }

  # OS-specific stuff
  # Desktop Shortcut
  case $::operatingsystem {
    'Fedora': {
      file { "${turbosite::camper_homedir}/Desktop/pycharm-community.desktop":
        source => 'file:///usr/share/applications/pycharm-community.desktop',
        mode   => '0755',
        owner  => $turbosite::camper_username
      }
    }
    default: {}
  }

}
