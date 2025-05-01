#
# Windows Update settings.
# The tag 'windowsupdate' allows us to run a minimal puppet run with only the things
# needed to manage Windows Updates right after kickstart.
#
# puppet agent -t --tags windowsupdate
# install-windowsupdate -acceptall -autoreboot
#
class profiles::windows::update {
  tag 'windowsupdate'

  # Set active hours
  registry_value { 'HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings\ActiveHoursStart':
    ensure => present,
    type   => dword,
    data   => 8 # 8AM
  }

  registry_value { 'HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings\ActiveHoursEnd':
    ensure => present,
    type   => dword,
    data   => 20 # 8PM
  }

  package { 'PSWindowsUpdate':
    provider => 'windowspowershell',
  }

  file { 'TurboUpdate.ps1':
    ensure => file,
    path   => 'C:\CampFitch\bin\TurboUpdate.ps1',
    source => 'puppet:///modules/cfcc/windows/TurboUpdate.ps1',
  }
}
