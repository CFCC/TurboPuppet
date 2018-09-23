#
# Common things that define a camper PC. System tools and the like.
# You'll note there is no explicit ordering here. Every profile should
# be independent of the others. If it is not, you should re-evaluate
# your life choices.
#
class profile::cfcc::camper {

    # OS-specific
    case $::kernel {
        'windows': {
            # Platform things
            include profile::firewall::windows
            include profile::winrm::server
            include profile::windows::rdp::enable
            include profile::windows::explorer
            include profile::windows::power
            include profile::windows::xbox::disable
            include profile::windows::update

            # OS-specific System 3rd Party Tools
            include profile::mdns::bonjour
            include profile::tools::spacemonger
            include profile::tools::cpuz
            include profile::tools::sevenzip

            # OS-specific Camper Tools
            # @TODO maybe this becomes profile::terminal::mobaxterm?
            include profile::tools::mobaxterm

            # Text editors. We all have opinions on these.
            include profile::editors::notepadplusplus
            #include profile::editors::atom
        }
        'Linux': {
            include profile::mdns::avahi
            # @TODO include profile::firewall::linux
            # @TODO include profile::ssh::server
            include profile::editors::vim
            include profile::editors::sublime
            # @TODO include profile::linux::windowmanager
        }
        default: {}
    }

    # System stuff
    include profile::puppet::agent::disable

    # Camper Tools
    include profile::browsers::chrome
    include profile::browsers::firefox
    include profile::tools::git
    include profile::tools::netbench

    # Games
    include profile::games::quake3
    include profile::games::steam
    include profile::games::minecraft
}
