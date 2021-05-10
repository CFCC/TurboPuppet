#
#
#
class profile::access::usericon {
  case $::operatingsystem {
    'windows': {
      $file_list = ['user.png', 'user-192.png', 'user-48.png', 'user-40.png', 'user-32.png']
      $file_list.each |$icon_file| {
        file { "C:/ProgramData/Microsoft/User Account Pictures/${icon_file}":
          source => "puppet:///campfs/UserIcons/${icon_file}",
          before => Registry_value['UseDefaultTile']
        }
      }

      registry_value { 'UseDefaultTile':
        path => 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\UseDefaultTile',
        type => 'dword',
        data => 1,
      }
    }
    'Fedora': {
      # Put the file to ~/.face
    }
    'Darwin': {
    }
    default: {
      fail("platform is unsupported")
    }
  }
}