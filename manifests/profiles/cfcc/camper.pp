#
# Common things that define a camper PC. System tools and the like.
#
class profiles::cfcc::camper {
    case $::osfamily {
        'windows': {
            include profiles::ccleaner
        }
        default: {
        }
    }
}
