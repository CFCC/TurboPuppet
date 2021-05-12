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
  exec { 'UninstallEdge':
    command => '& "$(Get-ChildItem -Path \"C:\Program Files (x86)\Microsoft\Edge\Application\" -Recurse -Filter setup.exe | select -ExpandProperty Directory | % { $_.FullName })\Setup.exe" -uninstall -system-level -verbose-logging -force-uninstall',
    onlyif  => psexpr('Get-Item -Path "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"')
  }

  file { 'EdgeDesktopShortcut':
    ensure => 'absent',
    path => "C:/Users/${turbosite::camper_username}/Desktop/Microsoft Edge.lnk"
  }
}
