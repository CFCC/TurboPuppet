#
# Quake III Arena
# @TODO - test that quake fitch works with ioquake3, because it derped hard in the VM.
#
class profiles::games::quake3 {
    case $::osfamily {
        'windows': {
            # I'm use the open-sauce ioquake3 engine and copying our pk3's into the right
            # places. This may or may not work in a real setting. Yolo.
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

            # @TODO q3config is in %APPDATA%\Quake3\baseq3

        }
        default: {
            fail("platform is unsupported")
        }
    }

}