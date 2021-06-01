#
#
#
class profile::cfcc::filesystem {

  # Was gonna do /usr/cfcc but apparently you can't do that on Mac....
  $fs_root = $::kernel ? {
    'windows' => 'C:/CampFitch',
    default   => '/opt/CampFitch'
  }

  File {
    ensure => directory,
    owner  => $turbosite::camper_username,
    group  => $::kernel ? {
      'windows' => 'administrators',
      default   => 'wheel'
    }
  }

  file { $fs_root: }

  # A reminder of general UNIX philosophy:
  # * /bin: Binary programs
  # * /etc: Configuration
  # * /usr: Misc
  # * /usr/share: Docs, installers, support content
  # * /opt: Custom user programs
  $subdirs = ['bin', 'etc', 'usr', 'usr/share', 'opt']
  $subdirs.each |String $subdir| {
    file { "${fs_root}/${subdir}":
      require => File[$fs_root]
    }
  }

  $buildinfo_path = "${fs_root}/etc/buildinfo.txt"
  exec { 'LogInitialBuild':
    command => $::kernel ? {
      'windows' => "Date | Out-File -FilePath ${buildinfo_path}",
      default   => "/bin/date > ${buildinfo_path}"
    },
    creates => $buildinfo_path,
    require => File["${fs_root}/etc"]
  }

  # Wallpaper
  file { "${fs_root}/usr/share/wallpaper":
    ensure  => 'directory',
    source  => 'puppet:///campfs/Wallpaper',
    recurse => 'remote',
    purge   => false,
    replace => false,
  }

}