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

            Dconf::Setting {
                user => $::turbosite::camper_username,
                uid  => $::turbosite::camper_uid
            }

            $profile_guid = 'b1dcc9dd-5262-4d8d-a863-c897e6d979b9'
            $terminal_profile_settings = {
                'visible-name'                    => 'camper',
                'use-theme-colors'                => false,
                'foreground-color'                => 'rgb(255,255,255)',
                'background-color'                => 'rgb(0,0,0)',
                'audible-bell'                    => false,
                'use-transparent-background'      => true,
                'background-transparency-percent' => 20,
                'login-shell'                     => 'true'
            }

            $terminal_profile_settings.each |String $key, String $value| {
                dconf::setting { $key:
                    key   => "/org/gnome/terminal/legacy/profiles:/:${profile_guid}/$key",
                    value => $value
                }
            } ->
            dconf::setting { 'default-profile-list':
                key   => '/org/gnome/terminal/legacy/profiles:/list',
                value => "['${profile_guid}']"
            } ->
            dconf::setting { 'default-profile':
                key   => '/org/gnome/terminal/legacy/profiles:/default',
                value => $profile_guid
            }
        }
        default: {}
    }
}