#
# Manage TurboPuppet scripts
#
class profiles::puppet::turbopuppet {
  file { 'TurboPuppet.ps1':
    ensure => file,
    path   => 'C:\CampFitch\bin\TurboPuppet.ps1',
    source => "C:\\ProgramData\\PuppetLabs\\code\\environments\\${facts['environment']}\\scripts\\TurboPuppet.ps1",
  }

  file { 'InstallTurboPuppet.ps1':
    ensure => file,
    path   => 'C:\CampFitch\bin\InstallTurboPuppet.ps1',
    source => "C:\\ProgramData\\PuppetLabs\\code\\environments\\${facts['environment']}\\scripts\\InstallTurboPuppet.ps1",
  }
}
