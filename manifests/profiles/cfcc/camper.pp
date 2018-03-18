#
# Common things that define a camper PC. System tools and the like.
#
class profiles::cfcc::camper {

    # OS-specific
    case $::osfamily {
        'windows': {
            include profiles::tools::ccleaner
            include profiles::tools::notepadplusplus
            include profiles::tools::mobaxterm
        }
        default: { }
    }

    include profiles::browsers::chrome
    include profiles::browsers::firefox
    include profiles::tools::git

    # Games
    include profiles::games::quake3
    include profiles::games::steam
    include profiles::games::minecraft
}