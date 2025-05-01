#
#
#
class profiles::desktop::wallpaper {
  # Copy over our various wallpaper options.
  file { 'C:/CampFitch/usr/share/wallpaper':
    ensure  => 'directory',
    source  => "${lookup('campfs_uri')}\\Wallpaper",
    recurse => 'remote',
    purge   => false,
    replace => false,
  }

  # Set a default only if one has never been set before.
  case $facts['os']['family'] {
    'windows': {
      # This method (https://www.windowscentral.com/how-restrict-users-changing-desktop-background-windows-10)
      # prevents the user from changing the wallpaper, which we do not want.
      #
      # However this method works.... but needs a reboot.
      # https://www.windows-commandline.com/change-windows-wallpaper-command-line/
      #
      # The default value is C:\Windows\web\wallpaper\Windows\img0.jpg.
      #
      # This script uses the API to set the wallpaper, which allows users to changte it
      # https://superuser.com/questions/398605/how-to-force-windows-desktop-background-to-update-or-refresh
      file { 'SetWallpaper':
        path   => 'C:/CampFitch/bin/SetWallpaper.ps1',
        owner  => lookup('camper_username'),
        source => 'puppet:///modules/cfcc/windows/SetWallpaper.ps1',
      }
      # Used to do -like "*img0.jpg" but by default in our Windows 11 it's empty.
      exec { 'SetWallpaper':
        # @formatter:off
        command => 'C:\CampFitch\bin\SetWallpaper.ps1 C:\CampFitch\usr\share\wallpaper\Bungalow.jpg',
        onlyif  => cfcc::psexpr('(Get-ItemProperty -Path "HKCU:Control Panel\Desktop" -Name "Wallpaper" |Select -ExpandProperty Wallpaper) -eq ""'),
        # @formatter:on
        require => File['SetWallpaper'],
      }
    }
    'Linux': {}
    default: {}
  }
}
