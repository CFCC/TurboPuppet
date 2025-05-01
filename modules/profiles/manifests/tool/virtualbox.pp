#
# VirtualBox
#
class profiles::tool::virtualbox (
  $package_name,
  $package_ensure,
) {
  # Oracles provides their own repository/key for vbox. However
  # for simplicity we will rely on the one built in RPMFusion
  # which for Fedora is in our base set of repos. Biggest disadvantage
  # is that RPMFusion doesn't let you control the release train (ie,
  # 5.1 vs 5.2). I've run into bugs with that before. Since we don't
  # really get that with Choco, oh well.
  $package_notify = $facts['os']['family'] ? {
    'windows' => [
      Exec['CleanupDesktopShortcuts'],
      Exec['DisableVboxHostAdapter'],
    ],
    default   => undef,
  }

  # Something happened in 6.1.34 that broke their automatic driver install.
  # Seems to be a bad code signing certificate somewhere in the chain.
  # Since we don't use this too much and I don't want to go digging the old
  # version is suffient for the time being. The net effect of the issues is that
  # the install hangs waiting for you to trust installing the drivers.
  package { $package_name:
    ensure => $package_ensure,
    notify => $package_notify,
  }

  # Guest Additions
  # Amazing that Windows does this for us.
  # @TODO Linux....
  case $facts['os']['family'] {
    'Darwin': {
      package { 'virtualbox-extension-pack': }
    }
    'windows': {
      # The VirtualBox Host-Only Network adapter makes certain LAN discovery operations
      # from "old" games such as TF2 and Quake 3 not work. Since we barely use VBox,
      # we just disable the adapter.
      file { 'DisableVboxHostAdapter':
        path   => 'C:/CampFitch/bin/DisableVboxHostAdapter.ps1',
        owner  => lookup('camper_username'),
        source => 'puppet:///modules/cfcc/windows/DisableVboxHostAdapter.ps1',
      }

      exec { 'DisableVboxHostAdapter':
        command     => 'C:\CampFitch\bin\DisableVboxHostAdapter.ps1',
        require     => File['DisableVboxHostAdapter'],
        refreshonly => true,
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
