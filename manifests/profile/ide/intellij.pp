#
#
#
class profile::ide::intellij {
  # Lock down the version we actually want.
  # $intellij_version = '2018.1.1'
  $intellij_version = '2019.1.3'

  $package_name = $::operatingsystem ? {
    'windows' => 'intellijidea-community',
    'Fedora'  => 'intellij-idea-community',
    'Darwin'  => 'intellij-idea-ce',
    default   => fail('Unsupported OS')
  }

  # Like Pycharm, Brew doesnt support ensure => version.
  package { $package_name:
    ensure => $::operatingsystem ? {
      'Darwin' => present,
      default  => $intellij_version
    }
  }

  # OS-specific stuff
  case $::operatingsystem {
    'Fedora': {
      # Desktop Shortcut
      file { "${turbosite::camper_homedir}/Desktop/intellij-idea-community.desktop":
        source => 'file:///usr/share/applications/intellij-idea-community.desktop',
        mode   => '0755',
        owner  => $turbosite::camper_username
      }
    }
    default: {}
  }

  # @TODO maybe figure out a way to auto-detect the installed JDK so that we don't have to set it manually.
}
