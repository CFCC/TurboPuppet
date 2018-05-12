#
#
#
class profile::ide::intellij {
    # Lock down the version we actually want.
    $intellij_version = '2017.3.3'

    $package_name = $::osfamily ? {
        'windows' => 'intellijidea-community',
        default   => fail('Unsupported OS')
    }

    package { $package_name:
        ensure => $intellij_version
    }

    case $::osfamily {
        'windows': {
            # Desktop Shortcut
            shortcut { "C:\\Users\\Public\\Desktop\\IntelliJ IDEA Community Edition ${intellij_version}.lnk":
                target => "C:\\Program Files (x86)\\JetBrains\IntelliJ IDEA Community Edition ${intellij_version}\\bin\\idea64.exe"
            }
            # @TODO maybe figure out a way to auto-detect the installed JDK so that we don't have to set it manually.
        }
        default: { }
    }
}