#
# PowerShell Modules
# https://forge.puppet.com/modules/hbuckle/powershellmodule
#
class profile::packaging::psmodule {
  pspackageprovider { 'Nuget':
    ensure => 'present'
  }

  include profile::packaging::repositories::windows
}
