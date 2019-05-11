#
# JavaScript is a plague on the world...
#
class role::cfcc::camper::web inherits role::cfcc::camper {

    case $::osfamily {
        'windows': {
            include profile::webserver::xampp
        }
        'Darwin': {
            # Web sharing is already a thing
        }
        default: {
            fail('Unsupported OS')
        }
    }

}
