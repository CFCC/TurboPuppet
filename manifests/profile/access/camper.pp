#
# Camper user access profile.
#
class profile::access::camper {
    case $::osfamily {
        'windows': {
            include profile::access::camper::windows
            $user_groups = ['BUILTIN\Administrators']
        }
        default: {
            fail("platform is unsupported")
        }
    }

    user { "${::site::cfcc::camper_username}":
        ensure   => present,
        groups   => $user_groups,
        # password => "${::site::cfcc::camper_username}",
    }
}