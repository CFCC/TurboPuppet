#
# Manage TurboPuppet scripts
#
class profiles::puppet::turbopuppet {
  file { 'TurboPuppet.ps1':
    ensure => file,
    path   => 'C:\CampFitch\bin\TurboPuppet.ps1',
    source => "C:\\ProgramData\\PuppetLabs\\code\\environments\\${facts['agent_specified_environment']}\\scripts\\TurboPuppet.ps1",
  }

  file { 'Install-TurboPuppet.ps1':
    ensure => file,
    path   => 'C:\CampFitch\bin\Install-TurboPuppet.ps1',
    source => "C:\\ProgramData\\PuppetLabs\\code\\environments\\${facts['agent_specified_environment']}\\scripts\\Install-TurboPuppet.ps1",
  }
}
