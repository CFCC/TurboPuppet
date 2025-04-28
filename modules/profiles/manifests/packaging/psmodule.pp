#
# PowerShell Modules
# https://forge.puppet.com/modules/hbuckle/powershellmodule
#
class profile::packaging::psmodule {
  pspackageprovider { 'Nuget':
    ensure => 'present',
  }

  include profiles::packaging::repositories::windows
  Pspackageprovider['Nuget'] -> Class['profiles::packaging::repositories::windows']
}
