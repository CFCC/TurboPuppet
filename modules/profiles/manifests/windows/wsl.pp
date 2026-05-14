#
# Windows Subsystem for Linux setup.
# This is intentionally split into two phases:
# 1) enable WSL prerequisites and mark reboot pending
# 2) after reboot and a second puppet run, install/bootstrap Ubuntu
#
class profiles::windows::wsl {
  $state_dir         = 'C:/CampFitch/state'
  $phase1_marker     = "${state_dir}/wsl_phase1_pending_reboot.txt"
  $ubuntu_distro     = 'Ubuntu'
  $camper_username   = lookup('camper_username')
  $post_reboot_guard = "(Test-Path -Path '${phase1_marker}') -and ((Get-CimInstance Win32_OperatingSystem).LastBootUpTime.ToUniversalTime() -gt (Get-Item '${phase1_marker}').LastWriteTimeUtc)"

  file { $state_dir:
    ensure => directory,
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
    onlyif  => cfcc::psexpr("((wsl.exe --status 2>\$null | Select-String -Pattern 'Default Version:\\s+2') -eq \$null)"),
    require => [
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
      Exec['SetWSLDefaultVersion2'],
    ],
    require     => File[$state_dir],
  }

  exec { 'NotifyWSLRebootRequired':
    command     => "Write-Output 'WSL prerequisites changed. Reboot Windows, then run puppet agent -t again to finish Ubuntu setup.'",
    refreshonly => true,
    subscribe   => Exec['MarkWSLPhase1PendingReboot'],
  }

  # Phase 2: post-reboot distro install and bootstrap.
  exec { 'InstallUbuntuLTS':
    command => "wsl.exe --install -d ${ubuntu_distro}",
    onlyif  => cfcc::psexpr("${post_reboot_guard} -and -not ((wsl.exe -l -q) -contains '${ubuntu_distro}')"),
  }

  exec { 'ConfigureUbuntuCamperUser':
    command => "wsl.exe -d ${ubuntu_distro} -u root -- bash -lc \"id -u ${camper_username} >/dev/null 2>&1 || useradd --create-home --user-group --groups sudo ${camper_username}; echo '[user]' > /etc/wsl.conf; echo 'default=${camper_username}' >> /etc/wsl.conf\"; wsl.exe --shutdown",
    onlyif  => cfcc::psexpr("${post_reboot_guard} -and ((wsl.exe -l -q) -contains '${ubuntu_distro}')"),
    require => Exec['InstallUbuntuLTS'],
  }

  exec { 'ClearWSLPhase1PendingRebootMarker':
    command => "Remove-Item -Path '${phase1_marker}' -Force",
    onlyif  => cfcc::psexpr("${post_reboot_guard} -and ((wsl.exe -l -q) -contains '${ubuntu_distro}')"),
    require => Exec['ConfigureUbuntuCamperUser'],
  }
}
