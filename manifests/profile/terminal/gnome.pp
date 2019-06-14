#
#
#
class profile::terminal::gnome {
    # https://github.com/ryansb/workstation/blob/master/roles/productivity/tasks/gsettings.yml

    case $::operatingsystem {
        'Fedora': {
            file { "${turbosite::camper_homedir}/Desktop/Terminal.desktop":
                source => 'file:///usr/share/applications/org.gnome.Terminal.desktop',
                mode   => '0755',
                owner  => $turbosite::camper_username
            }
        }
        default: {}
    }
}