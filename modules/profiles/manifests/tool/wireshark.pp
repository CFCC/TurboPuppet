#
# Wireshark
#
class profiles::tool::wireshark {
  # FC28 wireshark has both qt and gtk. The 'wireshark' metapackage
  # provides qt and cli.

  # Some platforms require extra things to make it work
  # case $::operatingsystem {
  #   'windows': {
  #     # Note - autohotkey doesn't behave well in VMs. Works fine for hardware.
  #     # winpcap is long abandoned. npcap doesnt have choco. Haven't found an automated solution yet.
  #     # package { 'winpcap':
  #     #   before => [ Package[$package_name] ]
  #     # }
  #   }
  # }

  package { 'wireshark': }
}
