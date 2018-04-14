#
# Windows-specific stuff for the camper access profile
#
class profile::access::camper::windows {
    include profile::windows::uac::disable
}