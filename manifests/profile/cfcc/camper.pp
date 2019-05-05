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
            include profile::desktop::explorer
            include profile::remoteaccess::rdp::enable
            include profile::remoteaccess::winrm::enable

            include profile::firewall::windows
            include profile::windows::power
            include profile::windows::xbox::disable
            include profile::windows::update

            # OS-specific System 3rd Party Tools
            include profile::mdns::bonjour
            include profile::tools::spacemonger
            include profile::tools::cpuz

            # OS-specific Camper Tools
            include profile::terminals::mobaxterm

            # Text editors. We all have opinions on these.
            include profile::editors::notepadplusplus
            #include profile::editors::atom
        }
        'Linux': {
            include profile::desktop::cinnamon
            include profile::remoteaccess::ssh::enable
            include profile::mdns::avahi
            # @TODO include profile::firewall::linux
            include profile::editors::vim
            include profile::editors::sublime
        }
        default: {}
    }

    # System-level stuff
    include profile::puppet::agent::disable

    # Camper & System Tools
    include profile::browsers::chrome
    include profile::browsers::firefox
    include profile::tools::git
    include profile::tools::wireshark
    include profile::tools::netbench
    include profile::tools::sevenzip
    include profile::tools::virtualbox

    # Games
    include profile::games::quake3
    include profile::games::steam
    include profile::games::minecraft
}
