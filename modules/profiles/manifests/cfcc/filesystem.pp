#
# CampFitch filesystem.
#
class profiles::cfcc::filesystem {
  # Was gonna do /usr/cfcc but apparently you can't do that on Mac....
  $fs_root = $facts['kernel'] ? {
    'windows' => 'C:/CampFitch',
    default   => '/opt/CampFitch',
  }

  $group = $facts['kernel'] ? {
    'windows' => 'administrators',
    default   => 'wheel',
  }

  File {
    ensure => directory,
    owner  => lookup('camper_username'),
    group  => $group,
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
      require => File[$fs_root],
    }
  }

  $buildinfo_path = "${fs_root}/etc/buildinfo.txt"
  $log_command = $facts['kernel'] ? {
    'windows' => "Date | Out-File -FilePath ${buildinfo_path}",
    default   => "/bin/date > ${buildinfo_path}",
  }

  exec { 'LogInitialBuild':
    command => $log_command,
    creates => $buildinfo_path,
    require => File["${fs_root}/etc"],
  }
}
