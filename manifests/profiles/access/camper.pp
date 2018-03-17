#
#
#
class profiles::access::camper {
    case $::osfamily {
        'windows': {
            include profiles::access::camper::windows
        }
        default: {
            fail("platform is unsupported")
        }
    }
}