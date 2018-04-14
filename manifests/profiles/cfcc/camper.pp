#
# Common things that define a camper PC. System tools and the like.
#
class profile::cfcc::camper {

    # OS-specific
    case $::osfamily {
        'windows': {
            include profile::tools::ccleaner
            include profile::tools::notepadplusplus
            include profile::tools::mobaxterm
        }
        default: { }
    }

    include profile::browsers::chrome
    include profile::browsers::firefox
    include profile::tools::git

    # Games
    include profile::games::quake3
    include profile::games::steam
    include profile::games::minecraft
}