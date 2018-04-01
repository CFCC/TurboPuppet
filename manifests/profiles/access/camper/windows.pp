#
# Windows-specific stuff for the camper access profile
#
class profiles::access::camper::windows {
    include profiles::windows::uac::disable
}