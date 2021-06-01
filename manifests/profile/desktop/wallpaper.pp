#
#
#
class profile::desktop::wallpaper {
  # Copy over our various wallpaper options.
  file { 'C:/CampFitch/usr/share/wallpaper':
    ensure  => 'directory',
    source  => 'puppet:///campfs/Wallpaper',
    recurse => 'remote',
    purge   => false,
    replace => false,
  }

  # Set a default only if one has never been set before.
  case $::kernel {
    'windows': {
      # https://www.windowscentral.com/how-restrict-users-changing-desktop-background-windows-10
      hkcu { 'Wallpaper':
        key    => 'Software\Microsoft\Windows\CurrentVersion\Policies\System',
        value  => 'Wallpaper',
        data   => 'C:\CampFitch\usr\share\wallpaper\bliss.jpg',
        notify => Exec['Reload Explorer']
      }
      hkcu { 'WallpaperStyle':
        key    => 'Software\Microsoft\Windows\CurrentVersion\Policies\System',
        value  => 'WallpaperStyle',
        data   => 4, # fill
        notify => Exec['Reload Explorer']
      }
    }
    'Linux': {}
  }
}