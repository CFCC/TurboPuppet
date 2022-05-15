#
# Setup Chocolatey package system.
# NOTE - to install packages you need to set provider => chocolatey on your
# Package resources. This is done for you in role::base.
#
class profile::packaging::chocolatey {
  class { 'chocolatey': }

  # Sometime since the 2019 camp season Choco started needing this in order
  # to not explode on the first Puppet run. Subsequent runs were fine but the
  # first exploded in a red fireball of death logs. While this likely has
  # some security implications it seems to get the job done.
  exec { 'DisableConfirmation':
    command => 'C:\ProgramData\chocolatey\choco.exe feature enable -n allowGlobalConfirmation',
    onlyif  => psexpr("(C:\\ProgramData\\chocolatey\\choco.exe feature list | Select-String -Pattern 'allowGlobalConfirmation') -Match \"\\[ \\]\""),
    require => Class['chocolatey']
  }

  # Had a bright idea to use a shared network mount as the Chocolatey package cache location.
  # Worked alright except that it wouldn't come up on reboot and other weird install errors
  # manifested themselves. Like packages refused to install. It caches about 1.6GB of content
  # so that's not nothing but it's worthless if it isn't reliable. Disabling until some
  # other day.
  # This is used in tandem with the mount defined in profile::storage::mountpoints.
  chocolateyconfig { 'cachelocation':
    #value   => "F:\\windows\\Chocolatey",
    #require => Mount['F:']
    ensure => absent
  }

  include profile::packaging::repositories::windows
}
