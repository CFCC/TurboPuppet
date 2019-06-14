#
# SublimeText Editor
#
class profile::editor::sublime {
    package { 'sublime-text': }

    # Desktop Shortcut
    case $::operatingsystem {
        'Fedora': {
            file { "${turbosite::camper_homedir}/Desktop/sublime_text.desktop":
                source => 'file:///usr/share/applications/sublime_text.desktop',
                mode   => '0755',
                owner  => $turbosite::camper_username
            }
        }
        default: {}
    }
}
