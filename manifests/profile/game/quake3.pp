#
# Quake III Arena
#
class profile::game::quake3 {
  case $::kernel {
    'windows': { include profile::game::quake3::windows }
    'Linux': { include profile::game::quake3::linux }
    'darwin': { include profile::game::quake3::darwin }
    default: { fail("Unsuported OS") }
  }

  # I'm use the open-sauce ioquake3 engine and copying our pk3's into the right
  # places. This may or may not work in a real setting. Yolo.
  # Apparently ~ doesnt work with the console, and its SHIFT+ESC. Ok....
  # $quake_packages = $::operatingsystem ? {
  #   'windows' => ['ioquake3', 'ioquake3-data'],
  #   'Fedora'  => 'quake3',
  #   'Darwin'  => 'ioquake3',
  #   default   => fail("platform is unsupported")
  # }
  # package { $quake_packages: }

  # System configuration and content directory
  # $baseq3 = $::operatingsystem ? {
  #   'windows' => 'C:\Program Files (x86)\ioquake3\baseq3',
  #   'Fedora'  => '/usr/share/quake3/baseq3',
  #   'Darwin'  => '/Applications/ioquake3/baseq3',
  #   default   => fail("platform is unsupported")
  # }
  # file { 'system-baseq3':
  #   path    => $baseq3,
  #   ensure  => directory,
  #   require => Package[$quake_packages]
  # }

  # Per-user configuration
  $user_config_directories = $::operatingsystem ? {
    'windows' => [
      "C:/Users/${turbosite::camper_username}/AppData/Roaming/Quake3/",
      "C:/Users/${turbosite::camper_username}/AppData/Roaming/Quake3/baseq3"
    ],
    'Fedora'  => [
      "/home/${turbosite::camper_username}/.q3a",
      "/home/${turbosite::camper_username}/.q3a/baseq3"
    ],
    'Darwin'  => [
      "/Users/${turbosite::camper_username}/Library/Application Support/Quake3/",
      "/Users/${turbosite::camper_username}/Library/Application Support/Quake3/baseq3",
    ],
    default   => fail("platform is unsupported")
  }
  file { $user_config_directories:
    ensure  => directory,
  }

  # Defaults for all files here
  File {
    ensure  => file,
    #require => File['system-baseq3']
  }
  $source_repo = 'puppet:///campfs/Quake3Arena'

  # Base game content
  # file { "${baseq3}/pak0.pk3": source => "${source_repo}/baseq3/pak0.pk3" }
  # file { "${baseq3}/pak1.pk3": source => "${source_repo}/baseq3/pak1.pk3" }
  # file { "${baseq3}/pak2.pk3": source => "${source_repo}/baseq3/pak2.pk3" }
  # file { "${baseq3}/pak3.pk3": source => "${source_repo}/baseq3/pak3.pk3" }
  # file { "${baseq3}/pak4.pk3": source => "${source_repo}/baseq3/pak4.pk3" }
  # file { "${baseq3}/pak5.pk3": source => "${source_repo}/baseq3/pak5.pk3" }
  # file { "${baseq3}/pak6.pk3": source => "${source_repo}/baseq3/pak6.pk3" }
  # file { "${baseq3}/pak7.pk3": source => "${source_repo}/baseq3/pak7.pk3" }
  # file { "${baseq3}/pak8.pk3": source => "${source_repo}/baseq3/pak8.pk3" }

  # Our addons
  # file { "${baseq3}/ezdmCF2.pk3": source => "${source_repo}/baseq3/ezdmCF2.pk3" }
  # file { "${baseq3}/ezfountian.pk3": source => "${source_repo}/baseq3/ezfountian.pk3" }

  # License key
  # $q3key_path = $::operatingsystem ? {
  #   'windows' => "C:/Users/${turbosite::camper_username}/AppData/Roaming/Quake3/baseq3/q3key",
  #   'Fedora'  => "/home/${turbosite::camper_username}/.q3a/baseq3/q3key",
  #   'Darwin'  => "/Users/${turbosite::camper_username}/Library/Application Support/Quake3/baseq3/q3key",
  #   default   => fail("platform is unsupported")
  # }
  # file { 'q3key':
  #   path   => $q3key_path,
  #   source => "${source_repo}/baseq3/q3key",
  #   owner  => $turbosite::camper_username,
  # }
  # File[$user_config_directories] -> File['q3key']

  # Initial config
  # We don't want to constantly rewrite the config file, so we will
  # only deploy it once. After that the game is cut loose from Puppet
  # and any other changes will be on the user. If we need to do a mass
  # deploy we should be able to delete the file then run Puppet so that
  # it will deploy whatever change is needed.
  $config_file_path = $::operatingsystem ? {
    'windows' => "C:/Users/${turbosite::camper_username}/AppData/Roaming/Quake3/baseq3/q3config.cfg",
    'Fedora'  => "/home/${turbosite::camper_username}/.q3a/baseq3/q3config.cfg",
    'Darwin'  => "/Users/${turbosite::camper_username}/Library/Application Support/Quake3/baseq3/q3config.cfg",
    default   => fail("platform is unsupported")
  }
  file { 'q3config':
    path    => $config_file_path,
    replace => no,
    source  => 'puppet:///modules/cfcc/q3config.cfg',
    owner   => $turbosite::camper_username,
  }
  File[$user_config_directories] -> File['q3config']

  # Any last OS-specific stuff
  # case $::operatingsystem {
  #   'windows': {
  #     shortcut { 'C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Quake III Arena.lnk':
  #       target => 'C:\Program Files (x86)\ioquake3\ioquake3.x86.exe'
  #     }
  #   }
  #   'Fedora': {
  #     file { 'q3icon':
  #       path   => "${baseq3}/icon.png",
  #       source => "${source_repo}/icon.png",
  #     }
  #
  #     freedesktop::shortcut { 'Quake III Arena':
  #       exec       => "/usr/bin/quake3",
  #       comment    => 'Quake III Arena',
  #       icon       => "${baseq3}/icon.png",
  #       categories => ['Games']
  #     } ->
  #     file { "${turbosite::camper_homedir}/Desktop/quake3.desktop":
  #       source => 'file:///usr/local/share/applications/Quake III Arena.desktop',
  #       mode   => '0755',
  #       owner  => $turbosite::camper_username
  #     }
  #
  #     File['q3icon'] -> Freedesktop::Shortcut['Quake III Arena']
  #   }
  #   'Darwin': {
  #     # @TODO shortcut resource.
  #     # https://apple.stackexchange.com/questions/51709/can-i-create-a-desktop-shortcut-alias-to-a-folder-from-the-terminal
  #     # .app is a file as far as osascript is concerned
  #   }
  #   default: {}
  # }
}
