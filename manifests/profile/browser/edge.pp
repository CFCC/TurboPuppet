#
# Microsft Edge web browser
# This profile has the distinction of being the only one to REMOVE rather than INSTALL.
# https://lifehacker.com/how-to-uninstall-edge-chromium-when-windows-10-wont-let-1844297854
#
class profile::browser::edge {
  exec { 'UninstallEdge':
    command => '& "$(Get-ChildItem -Recurse -Filter setup.exe | select -ExpandProperty Directory | % { $_.FullName })\Setup.exe" -uninstall -system-level -verbose-logging -force-uninstall',
    onlyif  => psexpr('Get-Item -Path "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"')
  }

  file { 'EdgeDesktopShortcut':
    ensure => 'absent',
    path => "C:/Users/${turbosite::camper_username}/Desktop/Microsoft Edge.lnk"
  }
}
