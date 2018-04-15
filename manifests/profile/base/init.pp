#
#
#
class profile::base {
    case $::osfamily {
        'windows': {
            include profile::base::windows
        }
        default: {
            fail("platform is unsupported")
        }
    }
}
