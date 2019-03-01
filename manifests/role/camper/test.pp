#
# Testing
#
class role::camper::test inherits role::camper {
    # include profile::remoteaccess::ssh::enable
    include profile::editors::gimp
}
