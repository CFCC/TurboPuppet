#
# Manage TurboPuppet scripts
#
class profiles::puppet::turbopuppet {
  $environment = $facts['agent_specified_environment'] ? {
    undef   => 'production',
    ''      => 'production',
    default => $facts['agent_specified_environment'],
  }

  file { 'TurboPuppet.ps1':
    ensure => file,
    path   => 'C:\CampFitch\bin\TurboPuppet.ps1',
    source => "C:\\ProgramData\\PuppetLabs\\code\\environments\\${environment}\\scripts\\TurboPuppet.ps1",
  }

  file { 'Install-TurboPuppet.ps1':
    ensure => file,
    path   => 'C:\CampFitch\bin\Install-TurboPuppet.ps1',
    source => "C:\\ProgramData\\PuppetLabs\\code\\environments\\${environment}\\scripts\\Install-TurboPuppet.ps1",
  }
}
