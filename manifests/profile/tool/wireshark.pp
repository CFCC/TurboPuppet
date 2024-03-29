#
# Wireshark
#
class profile::tool::wireshark {
  # FC28 wireshark has both qt and gtk. The 'wireshark' metapackage
  # provides qt and cli.
  $package_name = $::operatingsystem ? {
    default => 'wireshark'
  }

  # Some platforms require extra things to make it work
  case $::operatingsystem {
    'windows': {
      # Note - autohotkey doesn't behave well in VMs. Works fine for hardware.
      package { 'winpcap':
        before => [ Package[$package_name] ]
      }
    }
  }

  package { $package_name: }
}
