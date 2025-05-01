#
# SublimeText Editor
#
class profiles::editor::sublime (
  $package_name,
) {
  package { $package_name: }

  # Desktop Shortcut
  # case $facts['os']['family'] {
  #   'Fedora': {
  #     file { "${lookup('camper_homedir')}/Desktop/sublime_text.desktop":
  #       source => 'file:///usr/share/applications/sublime_text.desktop',
  #       mode   => '0755',
  #       owner  => lookup('camper_username'),
  #     }
  #   }
  #   default: {}
  # }
}
