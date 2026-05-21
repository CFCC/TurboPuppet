#
#
#
class profiles::access::usericon {
  case $facts['os']['family'] {
    'windows': {
      $file_list = ['user.png', 'user-192.png', 'user-48.png', 'user-40.png', 'user-32.png']
      $file_list.each |$icon_file| {
        file { "C:/ProgramData/Microsoft/User Account Pictures/${icon_file}":
          source => "${lookup('campfs_uri')}/UserIcons/${icon_file}",
          before => Registry_value['UseDefaultTile'],
        }
      }

      registry_value { 'UseDefaultTile':
        path => 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\UseDefaultTile',
        type => dword,
        data => 1,
      }
    }
    'Fedora': {
      # Put the file to ~/.face
    }
    'Darwin': {
      $username = lookup('camper_username')

      file { '/Library/User Pictures/CampFitch':
        ensure => directory,
        owner  => 'root',
        group  => 'wheel',
        mode   => '0755',
      }

      file { '/Library/User Pictures/CampFitch/camper.png':
        ensure  => file,
        owner   => 'root',
        group   => 'wheel',
        mode    => '0644',
        source  => "${lookup('campfs_uri')}/UserIcons/user.png",
        require => File['/Library/User Pictures/CampFitch'],
      }

      exec { 'Darwin set camper Picture attribute':
        command => "/usr/sbin/dscl . create '/Users/${username}' Picture '/Library/User Pictures/CampFitch/camper.png'",
        unless  => "/bin/bash -c \"/usr/sbin/dscl . -read '/Users/${username}' Picture 2>/dev/null | /usr/bin/grep -Fqx 'Picture: /Library/User Pictures/CampFitch/camper.png'\"",
        require => [
          File['/Library/User Pictures/CampFitch/camper.png'],
          User['camper'],
        ],
      }
    }
    default: {
      fail('platform is unsupported')
    }
  }
}
