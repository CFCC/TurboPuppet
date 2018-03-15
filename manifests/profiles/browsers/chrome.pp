#
#
#
class profiles::browsers::chrome {
#  package { 'Google Chrome':
#    ensure => 'present',
#    source => '\\\\TARS\Public\Camp Installers\Browsers\GoogleChromeStandaloneEnterprise64.msi',
#  }
#
    Package {
        provider => chocolatey
    }

    package { 'GoogleChrome':
        ensure => 'present',
    }
}
