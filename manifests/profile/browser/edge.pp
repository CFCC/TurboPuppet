#
# Microsft Edge web browser
# This profile has the distinction of being the only one to REMOVE rather than INSTALL.
# https://lifehacker.com/how-to-uninstall-edge-chromium-when-windows-10-wont-let-1844297854
#
class profile::browser::edge {
  # This is some hacks. Basically use PowerShell to find the setup.exe since it lives in a per-version
  # directory then run it with the required flags. Only do this if the Edge application exe is present.
  # https://stackoverflow.com/questions/13126175/get-full-path-of-the-files-in-powershell
  # https://stackoverflow.com/questions/4639894/executing-an-exe-file-using-a-powershell-script
  # It's a script so it can be run manually but also because it's a ton of escapes that make
  # it even less readable than it already is.
  file { 'EdgeRemover':
    path   => "C:/CampFitch/bin/EdgeRemover.ps1",
    owner  => $turbosite::camper_username,
    source => 'puppet:///modules/cfcc/windows/EdgeRemover.ps1'
  }

  exec { 'UninstallEdge':
    command => "C:/CampFitch/bin/EdgeRemover.ps1",
    onlyif  => psexpr('Get-Item -Path "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"'),
    require => File['EdgeRemover']
  }

  file { 'EdgeDesktopShortcut':
    ensure => 'absent',
    path   => "C:/Users/${turbosite::camper_username}/Desktop/Microsoft Edge.lnk"
  }
}
