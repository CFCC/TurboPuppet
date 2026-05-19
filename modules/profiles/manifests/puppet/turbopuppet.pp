#
# Manage TurboPuppet scripts
#
class profiles::puppet::turbopuppet {
  $environment = $facts['agent_specified_environment'] ? {
    undef   => 'production',
    ''      => 'production',
    default => $facts['agent_specified_environment'],
  }

  case $facts['kernel'] {
    'windows': {
      file { 'TurboPuppet.ps1':
        ensure => file,
        path   => 'C:/CampFitch/bin/TurboPuppet.ps1',
        source => "C:/ProgramData/PuppetLabs/code/environments/${environment}/scripts/TurboPuppet.ps1",
      }

      file { 'Install-TurboPuppet.ps1':
        ensure => file,
        path   => 'C:/CampFitch/bin/Install-TurboPuppet.ps1',
        source => "C:/ProgramData/PuppetLabs/code/environments/${environment}/scripts/Install-TurboPuppet.ps1",
      }
    }
    'Darwin', 'Linux': {
      $posix_script_root = lookup({
        name          => 'profiles::puppet::turbopuppet::posix_script_root',
        default_value => "${settings::codedir}/environments/${environment}/scripts",
      })

      file { 'turbopuppet.sh':
        ensure => file,
        path   => '/opt/CampFitch/bin/turbopuppet.sh',
        source => "${posix_script_root}/turbopuppet.sh",
        mode   => '0755',
      }

      file { 'install-turbopuppet.sh':
        ensure => file,
        path   => '/opt/CampFitch/bin/install-turbopuppet.sh',
        source => "${posix_script_root}/install-turbopuppet.sh",
        mode   => '0755',
      }
    }
    default: {}
  }
}
