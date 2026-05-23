#
# Windows Subsystem for Linux setup (post-reboot stage).
# Requires profiles::windows::wsl::preflight to have enabled optional features.
# Install-WSL.ps1 returns:
# - 0 when converged or no action is needed
# - 3010 when a reboot is required before continuing
# - 1 on hard failure
#
class profiles::windows::wsl {
  $ubuntu_distro   = 'Ubuntu'
  $camper_username = lookup('camper_username')
  $wsl_installer   = 'C:/CampFitch/bin/Install-WSL.ps1'

  require profiles::windows::wsl::preflight

  file { 'Install-WSL.ps1':
    ensure => file,
    path   => $wsl_installer,
    source => 'puppet:///modules/cfcc/windows/Install-WSL.ps1',
  }

  exec { 'InstallWSL':
    command   => "${wsl_installer} -Distro '${ubuntu_distro}' -CamperUsername '${camper_username}'",
    logoutput => true,
    returns   => [0, 3010],
    require   => [File['Install-WSL.ps1'], Class['profiles::windows::wsl::preflight']],
  }
}
