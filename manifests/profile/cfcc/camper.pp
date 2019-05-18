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
            include profile::tool::spacemonger
            include profile::tool::cpuz
            include profile::tool::gpuz

            # OS-specific Camper Tools
            include profile::terminal::mobaxterm

            # Text editors. We all have opinions on these.
            include profile::editor::notepadplusplus
            #include profile::editor::atom

            # Wumboze Games
             include profile::game::fortnite
        }
        'Linux': {
            include profile::desktop::cinnamon
            include profile::remoteaccess::ssh::enable
            include profile::mdns::avahi
            # @TODO include profile::firewall::linux
            include profile::editor::vim
            include profile::editor::sublime
        }
        default: {}
    }

    # System-level stuff
    include profile::puppet::agent::disable
    include profile::cfcc::filesystem

    # Camper & System Tools
    include profile::browser::chrome
    include profile::browser::firefox
    include profile::tool::git
    include profile::tool::wireshark
    include profile::tool::netbench
    include profile::tool::sevenzip
    include profile::tool::virtualbox
    include profile::tool::iperf

    # Games
    include profile::game::quake3
    include profile::game::steam
    include profile::game::minecraft
}
