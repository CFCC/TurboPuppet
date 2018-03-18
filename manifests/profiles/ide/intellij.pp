#
#
#
class profiles::ide::intellij {

    # Lock down the version we actually want.
    $version = '2017.3.3'

    $package_name = $::osfamily ? {
        'windows' => 'intellijidea-community',
        default   => fail('Unsupported OS')
    }

    package { $package_name:
        ensure => $version
    }

    shortcut { "C:/Users/Public/Desktop/IntelliJ IDEA Community Edition ${version}.lnk":
        target => "C:\Program Files (x86)\JetBrains\IntelliJ IDEA Community Edition ${version}\bin\idea64.exe"
    }
}