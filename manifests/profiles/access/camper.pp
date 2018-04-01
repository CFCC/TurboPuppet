#
# Camper user access profile.
#
class profiles::access::camper {
    case $::osfamily {
        'windows': {
            include profiles::access::camper::windows
            $user_groups = ['BUILTIN\Administrators']
        }
        default: {
            fail("platform is unsupported")
        }
    }

    user { "${::profiles::site::cfcc::camper_username}":
        ensure   => present,
        groups   => $user_groups,
        # password => "${::profiles::site::cfcc::camper_username}",
    }
}