#
# Javascript is a plague on the world...
#
class role::camper::web inherits role::camper {
    include profile::webserver::xampp
}
