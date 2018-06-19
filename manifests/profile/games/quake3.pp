#
# Quake III Arena
#
class profile::games::quake3 {
    case $::osfamily {
        'windows': {
            # I'm use the open-sauce ioquake3 engine and copying our pk3's into the right
            # places. This may or may not work in a real setting. Yolo.
            # Apparently ~ doesnt work with the console, and its SHIFT+ESC. Ok....
            $quake_packages = ['ioquake3', 'ioquake3-data']
            package { $quake_packages: }

            # Defaults for all files here
            File { ensure => file }
            $source_repo = '\\\\TARS\Public\Camp Games\Quake III Arena\baseq3'
            $target_dir = 'C:\Program Files (x86)\ioquake3\baseq3'

            # Custom map files
            file { "${target_dir}\\pak0.pk3":
                source => "${source_repo}\\pak0.pk3"
            }
            file { "${target_dir}\\ezdmCF2.pk3":
                source => "${source_repo}\\ezdmCF2.pk3"
            }
            file { "${target_dir}\\ezfountian.pk3":
                source => "${source_repo}\\ezfountian.pk3"
            }

            # q3config is in %APPDATA%\Quake3\baseq3
            $config_directories = [
                "C:/Users/${::site::cfcc::camper_username}/AppData/Roaming/Quake3/",
                "C:/Users/${::site::cfcc::camper_username}/AppData/Roaming/Quake3/baseq3"
            ]
            file { $config_directories:
                ensure => directory,
            }

            file { "q3key":
                path   => "C:/Users/${::site::cfcc::camper_username}/AppData/Roaming/Quake3/baseq3/q3key",
                source => "${source_repo}\\q3key"
            }

            # We don't want to constantly rewrite the config file, so we will
            # only deploy it once. After that the game is cut loose from Puppet
            # and any other changes will be on the user. If we need to do a mass
            # deploy we should be able to delete the file then run Puppet so that
            # it will deploy whatever change is needed.
            exec { 'q3config':
                command => "cp '${source_repo}\q3config.cfg' 'C:/Users/${::site::cfcc::camper_username}/AppData/Roaming/Quake3/baseq3/q3config.cfg'",
                unless  => psexpr("(Test-Path -Path C:/Users/${::site::cfcc::camper_username}/AppData/Roaming/Quake3/baseq3/q3config.cfg)")
            }

            shortcut { 'C:/Users/Public/Desktop/Quake III Arena.lnk':
                # icon_location => 'C:\ProgramData\scratch.ico',
                target => 'C:\Program Files (x86)\ioquake3\ioquake3.x86.exe'
            }

        }
        default: {
            fail("platform is unsupported")
        }
    }

}