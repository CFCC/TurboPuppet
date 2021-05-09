#
# Microsft Edge web browser
# This profile has the distinction of being the only one to REMOVE rather than INSTALL.
# https://lifehacker.com/how-to-uninstall-edge-chromium-when-windows-10-wont-let-1844297854
#
class profile::browser::edge {
  # This does not work. Windows says:
  #   C:\WINDOWS\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe failed. This app is part of Windows and cannot be
  #   uninstalled on a per-user basis. An administrator can attempt to remove the app from the computer using Turn Windows
  #   Features on or off. However, it may not be possible to uninstall the app.
  # It is more unfortunate.
  # appxpackage { 'Microsoft.MicrosoftEdge':
  #   ensure => 'absent',
  # }

  # However, running the installer method actually does work:
  # C:\Program Files (x86)\Microsoft\Edge\Application\90.0.818.56\Installer\setup.exe -uninstall -system-level -verbose-logging -force-uninstall
  # @TODO #12 need a way to make this not version-specific and idempotent.
}
