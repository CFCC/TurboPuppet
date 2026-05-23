#
# WSL preflight: enable Windows optional features before reboot.
# Tagged for turbopuppet -tags windowsupdate (kickstart / first-boot flow).
# Returns 3010 when a reboot is required; 0 when features are already enabled.
#
class profiles::windows::wsl::preflight {
  tag 'windowsupdate'

  $wsl_preflight = 'C:/CampFitch/bin/Install-WSLPreflight.ps1'

  file { 'Install-WSLPreflight.ps1':
    ensure => file,
    path   => $wsl_preflight,
    source => 'puppet:///modules/cfcc/windows/Install-WSLPreflight.ps1',
  }

  exec { 'WSLPreflight':
    command   => $wsl_preflight,
    logoutput => true,
    returns   => [0, 3010],
    require   => File['Install-WSLPreflight.ps1'],
  }
}
