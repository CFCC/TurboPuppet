#
# Chromium web browser
#
class profiles::browser::chromium (
  $package_name,
) {
  $package_notify = $facts['os']['family'] ? {
    'windows' => [
      Exec['CleanupChromiumDesktopShortcut'],
      Exec['CleanupDesktopShortcuts']
    ],
    default   => undef,
  }

  $install_options = $facts['os']['family'] ? {
    # Chrome updates so fscking frequently the package maintainers can't keep up leading to
    # occasional failures. Yes this has security implications.
    'windows' => '--ignore-checksums',
    default   => undef,
  }

  package { $package_name:
    notify          => $package_notify,
    install_options => $install_options,
  }

  # This works the first time, but a reboot puts the fraking thing back!
  exec { 'CleanupChromiumDesktopShortcut':
    command     => "Remove-Item -Path 'C:\\Users\\${lookup('camper_username')}\\Desktop\\Chromium.lnk'",
    refreshonly => true,
  }

  # Un. Believable.
  # https://techcommunity.microsoft.com/t5/enterprise/users-get-an-icon-placed-on-their-desktop-at-initial-logon/m-p/818249
  # https://www.itninja.com/question/google-chrome-enterprise-shortcuts-not-disappearing
  file { 'ChromiumMasterPreferences':
    path    => 'C:\Program Files\Chromium\Application\master_preferences',
    source  => 'puppet:///modules/cfcc/browsers/chrome_master_preferences.json',
    require => Package[$package_name],
    notify  => $package_notify,
  }

  # FOOLS!
  # I'm glad I'm not the only one out there.
  # https://github.com/PatchMyPCTeam/Community-Scripts/blob/main/Install/Post-Install/Google%20Chrome%20Desktop%20Shortcut/Remove-ChromeShortcut.ps1
  file { 'ChromiumInitialPreferences':
    path    => 'C:\Program Files\Chromium\Application\initial_preferences',
    source  => 'puppet:///modules/cfcc/browsers/chrome_initial_preferences.json',
    require => Package[$package_name],
    notify  => $package_notify,
  }
}
