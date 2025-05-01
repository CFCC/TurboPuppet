#
#
#
class profiles::windows::common {
  # @TODO gonna need this for other platforms.
  exec { 'CleanupDesktopShortcuts':
    command     => "Get-ChildItem -Path 'C:\\Users\\Public\\Desktop' -Filter '*.lnk' | Remove-Item",
    refreshonly => true,
  }
}
