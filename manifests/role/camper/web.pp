#
# JavaScript is a plague on the world...
#
class role::camper::web inherits role::camper {

    case $::operatingsystem {
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
