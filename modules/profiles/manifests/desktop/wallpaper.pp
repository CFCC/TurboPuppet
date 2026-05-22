#
#
#
class profiles::desktop::wallpaper {
  # Match profiles::cfcc::filesystem CampFitch root.
  $fs_root = $facts['kernel'] ? {
    'windows' => 'C:/CampFitch',
    default   => '/opt/CampFitch',
  }

  $wallpaper_dir = "${fs_root}/usr/share/wallpaper"

  $wallpaper_source = "${lookup('campfs_uri')}/Wallpaper"

  # Copy over our various wallpaper options.
  file { 'CampWallpaperLibrary':
    ensure  => 'directory',
    path    => $wallpaper_dir,
    source  => $wallpaper_source,
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
        path   => "${fs_root}/bin/SetWallpaper.ps1",
        owner  => lookup('camper_username'),
        source => 'puppet:///modules/cfcc/windows/SetWallpaper.ps1',
      }
      # Used to do -like "*img0.jpg" but by default in our Windows 11 it's empty.
      exec { 'SetWallpaper':
        # @formatter:off
        command => "${fs_root}/bin/SetWallpaper.ps1 ${wallpaper_dir}/boathouse.jpg",
        onlyif  => cfcc::psexpr('(Get-ItemProperty -Path "HKCU:Control Panel\Desktop" -Name "Wallpaper" |Select -ExpandProperty Wallpaper) -eq ""'),
        # @formatter:on
        require => File['SetWallpaper'],
      }
    }
    'Linux': {}
    'Darwin': {
      package { 'wallpaper':
        ensure => present,
      }
      exec { 'SetWallpaper':
        path    => ['/opt/homebrew/bin', '/usr/local/bin', '/usr/bin', '/bin'],
        command => "wallpaper set ${wallpaper_dir}/boathouse.jpg",
        unless  => "sh -c 'wallpaper get | grep -qF \"${wallpaper_dir}/boathouse.jpg\"'",
        require => [File['CampWallpaperLibrary'], Package['wallpaper']],
      }
    }
    default: {}
  }
}
