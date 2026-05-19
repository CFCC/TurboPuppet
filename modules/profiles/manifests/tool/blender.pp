#
# Blender
#
class profiles::tool::blender {
  $package_notify = $facts['kernel'] ? {
    'windows' => Exec['CleanupBlenderShortcut'],
    default   => undef,
  }

  package { 'blender':
    notify => $package_notify,
  }

  if $facts['os']['family'] == 'windows' {
    exec { 'CleanupBlenderShortcut':
      command     => "Remove-Item -Path 'C:\\Users\\${lookup('camper_username')}\\Desktop\\Blender*.lnk'",
      refreshonly => true,
    }
  }
}
