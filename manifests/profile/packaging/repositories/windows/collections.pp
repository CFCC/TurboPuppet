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

  # 3rd Party Collections "Supported"
  @chocolateysource { 'camp-chocolatey-community':
    location => 'https://nexus.apps.campcomputer.com/repository/chocolatey-community/',
    priority => '0',
  }

  @chocolateysource { 'chocolatey':
    ensure   => 'disabled',
    location => 'https://chocolatey.org/api/v2/',
    priority => '0',
  }
}
