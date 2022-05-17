#
#
#
class profile::packaging::repositories::windows::collections {

  Chocolateysource {
    ensure             => present,
    tag                => ['chocolateysource-collections'],
    admin_only         => 'false',
    allow_self_service => 'false',
    bypass_proxy       => 'false',
    provider           => 'windows',
  }

  Psrepository {
    ensure              => present,
    installation_policy => 'trusted',
    tag                 => ['psrepository-collections'],
    require             => Pspackageprovider['Nuget']
  }

  # 3rd Party Collections "Supported"
  # Local caching doesn't actually get us anything because the installers are all
  # scattered across the entire internet. Just the metadata comes from the community
  # repo. Big sad.
  # @chocolateysource { 'camp-chocolatey-community':
  #   location => 'https://nexus.apps.campcomputer.com/repository/chocolatey-community/',
  #   priority => '0',
  # }

  @chocolateysource { 'chocolatey':
    location => 'https://community.chocolatey.org/api/v2/',
    priority => '0',
  }

  @psrepository { 'PSGallery':
    source_location => 'https://www.powershellgallery.com/api/v2'
  }
}
