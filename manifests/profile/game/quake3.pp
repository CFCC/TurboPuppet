#
# Quake III Arena
#
# NOTE - the ordering here is somewhat complex. Take the pill that
# says "I Believe".
#
class profile::game::quake3 {

    # I'm use the open-sauce ioquake3 engine and copying our pk3's into the right
    # places. This may or may not work in a real setting. Yolo.
    # Apparently ~ doesnt work with the console, and its SHIFT+ESC. Ok....
    $quake_packages = $::osfamily ? {
        'windows' => ['ioquake3', 'ioquake3-data'],
        'RedHat'  => 'quake3',
        'Darwin'  => 'ioquake3',
        default   => fail("platform is unsupported")
    }
    package { $quake_packages: }

    # System configuration and content directory
    $baseq3 = $::osfamily ? {
        'windows' => 'C:\Program Files (x86)\ioquake3\baseq3',
        'RedHat'  => '/usr/share/quake3/baseq3',
        'Darwin'  => '/Applications/ioquake3/baseq3',
        default   => fail("platform is unsupported")
    }
    file { 'system-baseq3':
        path    => $baseq3,
        ensure  => directory,
        require => Package[$quake_packages]
    }

    # Per-user configuration
    $user_config_directories = $::osfamily ? {
        'windows' => [
            "C:/Users/${turbosite::camper_username}/AppData/Roaming/Quake3/",
            "C:/Users/${turbosite::camper_username}/AppData/Roaming/Quake3/baseq3"
        ],
        'RedHat'  => [
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
        require => Package[$quake_packages]
    }

    # Defaults for all files here
    File {
        ensure  => file,
        require => File['system-baseq3']
    }
    $source_repo = 'puppet:///campfs/Quake3Arena'

    # Base game content
    file { "${baseq3}/pak0.pk3": source => "${source_repo}/baseq3/pak0.pk3" }
    file { "${baseq3}/pak1.pk3": source => "${source_repo}/baseq3/pak1.pk3" }
    file { "${baseq3}/pak2.pk3": source => "${source_repo}/baseq3/pak2.pk3" }
    file { "${baseq3}/pak3.pk3": source => "${source_repo}/baseq3/pak3.pk3" }
    file { "${baseq3}/pak4.pk3": source => "${source_repo}/baseq3/pak4.pk3" }
    file { "${baseq3}/pak5.pk3": source => "${source_repo}/baseq3/pak5.pk3" }
    file { "${baseq3}/pak6.pk3": source => "${source_repo}/baseq3/pak6.pk3" }
    file { "${baseq3}/pak7.pk3": source => "${source_repo}/baseq3/pak7.pk3" }
    file { "${baseq3}/pak8.pk3": source => "${source_repo}/baseq3/pak8.pk3" }

    # Our addons
    file { "${baseq3}/ezdmCF2.pk3": source => "${source_repo}/baseq3/ezdmCF2.pk3" }
    file { "${baseq3}/ezfountian.pk3": source => "${source_repo}/baseq3/ezfountian.pk3" }

    # License key
    $q3key_path = $::osfamily ? {
        'windows' => "C:/Users/${turbosite::camper_username}/AppData/Roaming/Quake3/baseq3/q3key",
        'RedHat'  => "/home/${turbosite::camper_username}/.q3a/baseq3/q3key",
        'Darwin'  => "/Users/${turbosite::camper_username}/Library/Application Support/Quake3/baseq3/q3key",
        default   => fail("platform is unsupported")
    }
    file { 'q3key':
        path   => $q3key_path,
        source => "${source_repo}/baseq3/q3key",
        owner  => $turbosite::camper_username,
    }
    File[$user_config_directories] -> File['q3key']

    # Initial config
    # We don't want to constantly rewrite the config file, so we will
    # only deploy it once. After that the game is cut loose from Puppet
    # and any other changes will be on the user. If we need to do a mass
    # deploy we should be able to delete the file then run Puppet so that
    # it will deploy whatever change is needed.
    $config_file_path = $::osfamily ? {
        'windows' => "C:/Users/${turbosite::camper_username}/AppData/Roaming/Quake3/baseq3/q3config.cfg",
        'RedHat'  => "/home/${turbosite::camper_username}/.q3a/baseq3/q3config.cfg",
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
    case $::osfamily {
        'windows': {
            shortcut { 'C:/Users/Public/Desktop/Quake III Arena.lnk':
                # icon_location => 'C:\ProgramData\scratch.ico',
                target => 'C:\Program Files (x86)\ioquake3\ioquake3.x86.exe'
            }
        }
        'RedHat': {
            file { 'q3icon':
                path   => "${baseq3}/icon.png",
                source => "${source_repo}/icon.png",
            }

            freedesktop::shortcut { 'Quake III Arena':
                exec       => "/usr/bin/quake3",
                comment    => 'Quake III Arena',
                icon       => "${baseq3}/icon.png",
                categories => ['Games']
            }

            File['q3icon'] -> Freedesktop::Shortcut['Quake III Arena']
        }
        'Darwin': {
            # @TODO shortcut resource.
            # https://apple.stackexchange.com/questions/51709/can-i-create-a-desktop-shortcut-alias-to-a-folder-from-the-terminal
            # .app is a file as far as osascript is concerned
        }
        default: {}
    }

}
