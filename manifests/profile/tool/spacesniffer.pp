#
#
#
class profile::tool::spacesniffer {

  package { 'spacesniffer': }

  shortcut { 'spacesniffer':
    path    => 'C:/ProgramData/Microsoft/Windows/Start Menu/Programs/SpaceSniffer.lnk',
    target  => 'C:/ProgramData/chocolatey/bin/SpaceSniffer.exe',
    require => Package['spacesniffer']
  }
}