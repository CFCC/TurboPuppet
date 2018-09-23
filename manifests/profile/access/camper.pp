#
# Camper user access profile.
#
class profile::access::camper {

    # In other places we key off of the $::kernel fact. That doesn't
    # work for us here since different distros have different groups.
    case $::osfamily {
        'windows': {
            include profile::access::camper::windows
            # $user_groups = ['BUILTIN\Administrators', "BUILTIN\Remote Management Users"]
            $user_groups = ['BUILTIN\Administrators']
        }
        'RedHat': {
            # camper : camper adm cdrom sudo dip plugdev lpadmin sambashare
            $user_groups = ['wheel']
        }
        default: {
            fail("platform is unsupported")
        }
    }

    user { "${turbosite::camper_username}":
        ensure   => present,
        groups   => $user_groups,
        # password => "${turbosite::camper_username}",
    }

    include profile::access::autologin::enable
}
