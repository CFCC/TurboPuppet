#
#
#
class profiles::packaging {
	case $::osfamily {
		'windows': {
            include profiles::packaging::chocolatey
		}
		default: {
            fail("platform is unsupported")
        }
	}
}
