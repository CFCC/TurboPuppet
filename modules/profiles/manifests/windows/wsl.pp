#
# Windows Subsystem for Linux setup.
# The orchestration logic lives in Install-WSL.ps1, which returns:
# - 0 when converged or no action is needed
# - 3010 when a reboot is required before continuing
# - 1 on hard failure
#
class profiles::windows::wsl {
  $state_dir      = 'C:/CampFitch/var/state'
  $phase1_marker  = "${state_dir}/wsl_phase1_pending_reboot.txt"
  $ubuntu_distro  = 'Ubuntu'
  $camper_username = lookup('camper_username')
  $wsl_installer  = 'C:/CampFitch/bin/Install-WSL.ps1'

  file { $state_dir:
    ensure => directory,
  }

  file { 'Install-WSL.ps1':
    ensure => file,
    path   => $wsl_installer,
    source => 'puppet:///modules/cfcc/windows/Install-WSL.ps1',
  }

  exec { 'InstallWSL':
    command => "${wsl_installer} -MarkerPath '${phase1_marker}' -Distro '${ubuntu_distro}' -CamperUsername '${camper_username}'",
    logoutput => true,
    returns => [0, 3010],
    require => [
      File[$state_dir],
      File['Install-WSL.ps1'],
    ],
  }
}
