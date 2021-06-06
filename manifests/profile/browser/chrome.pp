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
    'windows' => [ Exec['CleanupChromeDesktopShortcut'], Exec['CleanupDesktopShortcuts'] ],
    default   => undef,
  }

  package { $package_name:
    notify => $package_notify,
  }

  # This works the first time, but a reboot puts the fraking thing back!
  exec { 'CleanupChromeDesktopShortcut':
    command     => "Remove-Item -Path 'C:\\Users\\${turbosite::camper_username}\\Desktop\\Google Chrome.lnk'",
    refreshonly => true
  }

  # Un. Believable.
  # https://techcommunity.microsoft.com/t5/enterprise/users-get-an-icon-placed-on-their-desktop-at-initial-logon/m-p/818249
  # https://www.itninja.com/question/google-chrome-enterprise-shortcuts-not-disappearing
  file { 'ChromeMasterPreferences':
    ensure  => present,
    path    => 'C:\Program Files\Google\Chrome\Application\master_preferences',
    source  => 'puppet:///modules/cfcc/browsers/chrome_master_preferences.json',
    require => Package[$package_name],
    notify  => $package_notify,
  }

}
