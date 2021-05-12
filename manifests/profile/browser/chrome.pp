#
# Google Chrome web browser
#
class profile::browser::chrome {

  $package_name = $::kernel ? {
    'windows' => 'GoogleChrome',
    'Linux'   => 'google-chrome-stable',
    'Darwin'  => 'google-chrome',
    default   => fail('Unsupported OS')
  }

  $package_notify = $::kernel ? {
    'windows' => Exec['CleanupDesktopShortcuts'],
    default   => undef,
  }

  package { $package_name:
    notify => $package_notify,
  }

}
