#
#
#
class profiles::browser::chrome {
  package { 'Google Chrome':
    ensure => 'present',
    source => '\\\\TARS\Public\Camp Installers\Browsers\GoogleChromeStandaloneEnterprise64.msi',
  }
}