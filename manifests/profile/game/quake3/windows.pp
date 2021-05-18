#
#
#
class profile::game::quake3::windows {
  # The packages ioquake3 and ioquake3-data are broken as of 2021-05-18.
  # Reverting to our classic copy-n-paste method.
  $quake3_root = 'C:/CampFitch/opt/Quake 3 Arena'

  # https://puppet.com/docs/puppet/7.6/types/file.html#file-attribute-purge
  file { 'Quake3Content':
    ensure  => 'directory',
    source  => 'puppet:///campfs/Quake3Arena',
    path    => $quake3_root,
    recurse => 'remote',
    purge   => false,
    replace => false,
  }

  shortcut { 'Quake3Shortcut':
    path    => 'C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Quake 3 Arena.lnk',
    target  => "${quake3_root}/QUAKE3.EXE",
    require => File['Quake3Content']
  }

}