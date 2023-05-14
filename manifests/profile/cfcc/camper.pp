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
      include profile::windows::xbox::disable
      include profile::windows::update
      # include profile::windows::wsl
      include profile::windows::dotnet
      include profile::windows::apps

      # OS-specific System 3rd Party Tools
      include profile::tool::spacesniffer
      include profile::tool::cpuz
      include profile::tool::procmon
      include profile::tool::gpuz
      include profile::tool::produkey

      # OS-specific Camper Tools
      include profile::terminal::windows
      include profile::browser::edge

      # Text editors. We all have opinions on these.
      include profile::editor::notepadplusplus

      # Wumboze Games
      include profile::game::epic
      include profile::game::origin
    }
    'Linux': {
      include profile::desktop::cinnamon
      include profile::remoteaccess::ssh::enable
      # @TODO include profile::firewall::linux
      include profile::editor::vim
      include profile::editor::sublime
      include profile::terminal::gnome
    }
    default: {}
  }

  # System-level stuff
  include profile::puppet::agent::disable
  include profile::mdns::client
  include profile::cfcc::filesystem
  # #47 disabling since the Zotac driver issues seem to no longer be relevant.
  #include profile::power::alwayson
  include profile::remoteaccess::vnc::enable
  include profile::desktop::wallpaper
  include profile::tls::certificates

  # Camper & System Tools
  include profile::browser::chrome
  include profile::browser::firefox
  include profile::tool::git
  include profile::tool::wireshark
  include profile::tool::netbench
  include profile::tool::sevenzip
  include profile::tool::virtualbox
  include profile::tool::iperf
  include profile::tool::vlc

  # Games
  include profile::game::quake3
  include profile::game::steam
  include profile::game::minecraft
}
