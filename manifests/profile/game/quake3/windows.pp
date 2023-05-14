#
#
#
class profile::game::quake3::windows {
  # The packages ioquake3 and ioquake3-data are broken as of 2021-05-18.
  # Upstream exe installer has been moved. Since ioquake3 distributes a zip,
  # I'm cheating and distributing that with our content.
  $quake3_root = 'C:/CampFitch/opt/Quake 3 Arena'

  # https://puppet.com/docs/puppet/7.6/types/file.html#file-attribute-purge
  file { 'Quake3Content':
    ensure  => 'directory',
    source  => 'puppet:///campfs/ioquake3',
    path    => $quake3_root,
    recurse => 'remote',
    purge   => false,
    replace => false,
  }

  shortcut { 'Quake3Shortcut':
    path              => 'C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Quake 3 Arena.lnk',
    working_directory => $quake3_root,
    target            => "${quake3_root}/ioquake3.x86_64.exe",
    require           => File['Quake3Content']
  }

}
