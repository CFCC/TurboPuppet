#
# Windows Subsystem for Linux setup.
# This is intentionally split into two phases:
# 1) enable WSL prerequisites and mark reboot pending
# 2) after reboot and a second puppet run, install/bootstrap Ubuntu
#
class profiles::windows::wsl {
  $state_dir         = 'C:/CampFitch/var/state'
  $phase1_marker     = "${state_dir}/wsl_phase1_pending_reboot.txt"
  $ubuntu_distro     = 'Ubuntu'
  $camper_username   = lookup('camper_username')
  $wsl_guard_script  = 'C:/CampFitch/bin/WslGuard.ps1'

  file { $state_dir:
    ensure => directory,
  }

  file { 'WslGuard.ps1':
    ensure => file,
    path   => $wsl_guard_script,
    source => 'puppet:///modules/cfcc/windows/WslGuard.ps1',
  }

  # Phase 1: enable required Windows features and WSL defaults.
  exec { 'EnableWSLFeature':
    command => 'dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart',
    onlyif  => cfcc::psexpr("(Get-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Windows-Subsystem-Linux' | Select -ExpandProperty State) -ne 'Enabled'"),
    returns => [0, 3010],
  }

  exec { 'EnableVirtualMachinePlatform':
    command => 'dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart',
    onlyif  => cfcc::psexpr("(Get-WindowsOptionalFeature -Online -FeatureName 'VirtualMachinePlatform' | Select -ExpandProperty State) -ne 'Enabled'"),
    returns => [0, 3010],
  }

  exec { 'SetWSLDefaultVersion2':
    command => 'wsl.exe --set-default-version 2',
    onlyif  => "${wsl_guard_script} -Check DefaultVersionNeedsSet -MarkerPath '${phase1_marker}' -Distro '${ubuntu_distro}'",
    require => [
      File['WslGuard.ps1'],
      Exec['EnableWSLFeature'],
      Exec['EnableVirtualMachinePlatform'],
    ],
  }

  # If anything in phase 1 changes, we mark and emit a clear reboot notice.
  exec { 'MarkWSLPhase1PendingReboot':
    command     => "New-Item -Path '${phase1_marker}' -ItemType File -Force | Out-Null; Set-Content -Path '${phase1_marker}' -Value (Get-Date -Format o)",
    refreshonly => true,
    subscribe   => [
      Exec['EnableWSLFeature'],
      Exec['EnableVirtualMachinePlatform'],
    ],
    require     => File[$state_dir],
  }

  # Recovery path: if phase 1 succeeded earlier but marker creation was skipped
  # (for example due to a past mid-run error), recreate the marker.
  exec { 'BackfillWSLPhase1PendingRebootMarker':
    command => "New-Item -Path '${phase1_marker}' -ItemType File -Force | Out-Null; Set-Content -Path '${phase1_marker}' -Value (Get-Date -Format o)",
    onlyif  => "${wsl_guard_script} -Check BackfillNeeded -MarkerPath '${phase1_marker}' -Distro '${ubuntu_distro}'",
    require => [
      File[$state_dir],
      File['WslGuard.ps1'],
    ],
  }

  exec { 'NotifyWSLRebootRequired':
    command => "Write-Output 'WSL prerequisites changed. Reboot Windows, then run puppet agent -t again to finish Ubuntu setup.'",
    onlyif  => "${wsl_guard_script} -Check RebootPending -MarkerPath '${phase1_marker}'",
    require => [
      Exec['MarkWSLPhase1PendingReboot'],
      Exec['BackfillWSLPhase1PendingRebootMarker'],
      File['WslGuard.ps1'],
    ],
  }

  # Phase 2: post-reboot distro install and bootstrap.
  exec { 'InstallUbuntuLTS':
    command => "wsl.exe --install -d ${ubuntu_distro}",
    onlyif  => "${wsl_guard_script} -Check DistroMissingPostReboot -MarkerPath '${phase1_marker}' -Distro '${ubuntu_distro}'",
    require => File['WslGuard.ps1'],
  }

  exec { 'ConfigureUbuntuCamperUser':
    command => "wsl.exe -d ${ubuntu_distro} -u root -- bash -lc \"id -u ${camper_username} >/dev/null 2>&1 || useradd --create-home --user-group --groups sudo ${camper_username}; echo '[user]' > /etc/wsl.conf; echo 'default=${camper_username}' >> /etc/wsl.conf\"; wsl.exe --shutdown",
    onlyif  => "${wsl_guard_script} -Check DistroPresentPostReboot -MarkerPath '${phase1_marker}' -Distro '${ubuntu_distro}'",
    require => Exec['InstallUbuntuLTS'],
  }

  exec { 'ClearWSLPhase1PendingRebootMarker':
    command => "Remove-Item -Path '${phase1_marker}' -Force",
    onlyif  => "${wsl_guard_script} -Check DistroPresentPostReboot -MarkerPath '${phase1_marker}' -Distro '${ubuntu_distro}'",
    require => Exec['ConfigureUbuntuCamperUser'],
  }
}
