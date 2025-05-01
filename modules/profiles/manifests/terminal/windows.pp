#
# Windows Terminal
#
class profiles::terminal::windows {
  # This comes default with Windows 11 now so yay!
  #package { 'microsoft-windows-terminal': }
  # This is broken. Need to install "Microsoft.VCLibs.140.00.UWPDesktop" somehow.
}
