#
# Common things that define a camper PC. System tools and the like.
# You'll note there is no explicit ordering here. Every profile should
# be independent of the others. If it is not, you should re-evaluate
# your life choices.
#
class profiles::cfcc::camper {
  # OS-specific
  # case $facts['os']['family'] {
  #   'windows': {
  #     # # Platform things
  #     # include profiles::desktop::explorer
  #     # include profiles::remoteaccess::rdp::enable
  #     # include profiles::remoteaccess::winrm::enable

  #     # include profiles::firewall::windows
  #     # include profiles::windows::xbox::disable
  #     # include profiles::windows::update
  #     # # include profiles::windows::wsl
  #     # include profiles::windows::dotnet
  #     # include profiles::windows::apps

  #     # # OS-specific System 3rd Party Tools
  #     # include profiles::tool::spacesniffer
  #     # include profiles::tool::cpuz
  #     # include profiles::tool::procmon
  #     # include profiles::tool::gpuz
  #     # include profiles::tool::produkey

  #     # # OS-specific Camper Tools
  #     # include profiles::terminal::windows
  #     # include profiles::browser::edge

  #     # # Text editors. We all have opinions on these.
  #     # include profiles::editor::notepadplusplus

  #     # # Wumboze Games
  #     # include profiles::game::epic
  #     # include profiles::game::origin
  #   }
  #   'Linux': {
  #     # include profiles::desktop::cinnamon
  #     # include profiles::remoteaccess::ssh::enable
  #     # # @TODO include profiles::firewall::linux
  #     # include profiles::editor::vim
  #     # include profiles::editor::sublime
  #     # include profiles::terminal::gnome
  #   }
  #   default: {}
  # }

  # System-level stuff
  # include profiles::puppet::agent::disable
  # include profiles::mdns::client
  # include profiles::cfcc::filesystem
  # # #47 disabling since the Zotac driver issues seem to no longer be relevant.
  include profiles::power::alwayson
  include profiles::remoteaccess::vnc::enable
  include profiles::desktop::wallpaper
  # include profiles::tls::certificates

  # # Camper & System Tools
  # include profiles::browser::chrome
  # include profiles::browser::firefox
  # include profiles::tool::git
  # include profiles::tool::wireshark
  # include profiles::tool::netbench
  # include profiles::tool::sevenzip
  # include profiles::tool::virtualbox
  # include profiles::tool::iperf
  # include profiles::tool::vlc
  # include profiles::tool::blender

  # # Games
  # include profiles::game::quake3
  # include profiles::game::steam
  # include profiles::game::minecraft
}
