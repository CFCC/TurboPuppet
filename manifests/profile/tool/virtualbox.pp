#
# VirtualBox
#
class profile::tool::virtualbox {
  # Oracles provides their own repository/key for vbox. However
  # for simplicity we will rely on the one built in RPMFusion
  # which for Fedora is in our base set of repos. Biggest disadvantage
  # is that RPMFusion doesn't let you control the release train (ie,
  # 5.1 vs 5.2). I've run into bugs with that before. Since we don't
  # really get that with Choco, oh well.
  $package_name = $::operatingsystem ? {
    'windows' => 'virtualbox',
    'Fedora'  => 'VirtualBox',
    'Darwin'  => 'virtualbox',
    default   => fail('Unsupported OS')
  }

  package { $package_name: }

  # Guest Additions
  # Amazing that Windows does this for us.
  # @TODO Linux....
  case $::operatingsystem {
    'Darwin': {
      package { 'virtualbox-extension-pack': }
    }
    'Fedora': {
      file { "${turbosite::camper_homedir}/Desktop/virtualbox.desktop":
        source => 'file:///usr/share/applications/virtualbox.desktop',
        mode   => '0755',
        owner  => $turbosite::camper_username
      }
    }
    default: {}
  }

  # 20190504 apparently Choco does this for us! Just leaves Linux to deal with...
  # Install GA
  #exec { foo:
  #    unless => "vboxmanage list extpacks | grep 'Oracle VM Virtualbox Extention Pack'"
  #}

}
