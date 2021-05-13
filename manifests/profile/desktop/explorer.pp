#
# Tweaks to Explorer.exe
#
class profile::desktop::explorer {
  # Disabling since WIN-X keystroke -> PowerShell works better and it's snowflaky as hell.
  # We want to preserve the "RunAsAdministrator" bit.
  # https://stackoverflow.com/questions/28997799/how-to-create-a-run-as-administrator-shortcut-using-powershell
  # file { 'C:/ProgramData/Microsoft/Windows/Start Menu/Programs/sudo cmd.lnk':
  #   source => 'puppet:///modules/cfcc/sudocmd.lnk',
  # }

  # Admin "God Mode" panel. This may be a bad idea.
  # https://www.howtogeek.com/402458/enable-god-mode-in-windows-10/
  # file { "C:/Users/${turbosite::camper_username}/Desktop/GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}":
  #   ensure => directory
  # }

  # Remove built-in shortcut files that are useless
  $junk_shortcuts = [
    "C:/Users/${turbosite::camper_username}/Desktop/Windows 10 Update Assistant.lnk",
    "C:/Users/Public/Desktop/3D Vision Photo Viewer.lnk"
  ]
  file { $junk_shortcuts: ensure => absent }

  # All edits need explorer.exe to reload before they take effect
  Hkcu {
    notify => Exec['Reload Explorer']
  }
  Registry_key {
    notify => Exec['Reload Explorer']
  }

  # Show file extensions
  hkcu { 'ShowFileExtensions':
    key   => 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced',
    value => 'HideFileExt',
    data  => 0,
  }

  # Show Hidden Files
  hkcu { 'ShowHiddenFiles':
    key   => 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced',
    value => 'Hidden',
    data  => 1,
  }

  # Remove search bar
  # https://www.askvg.com/how-to-remove-search-and-task-view-icons-from-windows-10-taskbar/
  hkcu { 'RemoveSearchBox':
    key   => 'Software\Microsoft\Windows\CurrentVersion\Search',
    value => 'SearchboxTaskbarMode',
    data  => 0,
  }

  # Remove taskbview button
  hkcu { 'RemoveTaskviewButton':
    key   => 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced',
    value => 'ShowTaskViewButton',
    data  => 0,
  }

  # Remove People button
  hkcu { 'RemovePeopleButton':
    key   => 'Software\Policies\Microsoft\Windows\Explorer',
    value => 'HidePeopleBar',
    data  => 1,
  }

  # Remove the mail icon from the taskbar. This is surprisingly harder than it should be.
  hkcu { 'RemoveTaskbandFavorites':
    key   => 'Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband',
    value => 'Favorites',
    data  => 255,
  }

  # Show full path to files in the title and address bar
  hkcu { 'DisplayFullPath':
    key   => 'Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState',
    value => 'FullPath',
    data  => 1
  }

  # Expand to current folder in nav tree
  hkcu { 'ExpandCurrentNavTree':
    key   => 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced',
    value => 'NavPaneExpandToCurrentFolder',
    data  => 1,
  }

  # Combine buttons on taskbar when full
  hkcu { 'TaskbarGlomLevel':
    key   => 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced',
    value => 'TaskbarGlomLevel',
    data  => 1,
  }

  # Shoot onedrive in the face
  hkcu { 'OnedriveAutostart':
    ensure => absent,
    key    => 'Software\Microsoft\Windows\CurrentVersion\Run',
    value  => 'OneDrive',
  }

  # Disable MeetNow (#17)
  registry_value { 'HideSCAMeetNow':
    path   => 'HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\HideSCAMeetNow',
    type   => 'dword',
    data   => 1,
    notify => Exec['Reload Explorer']
  }

  # Disable transparency
  # https://winaero.com/turn-on-or-off-transparency-effects-in-windows-10/
  hkcu { 'EnableTransparency':
    key   => 'SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize',
    value => 'EnableTransparency',
    data  => 0,
  }

  # Add an Open with Notepad action to context menu of every file
  registry_key { 'OpenWithNotepadKey':
    path   => 'HKCR\*\shell\Open with Notepad',
    ensure => present,
  }
  registry_key { 'OpenWithNotepadCommandKey':
    path   => 'HKCR\*\shell\Open with Notepad\command',
    ensure => present,
  }
  registry::value { 'OpenWithNotepadCommandValue':
    key    => 'HKCR\*\shell\Open with Notepad\command',
    value  => '(default)',
    data   => 'notepad.exe %1',
    notify => Exec['Reload Explorer']
  }

  # Disable re-opening programs after reboot
  # https://superuser.com/questions/1229963/windows-10-disable-reopening-programs-after-restart-startup
  registry_value { 'DisableAutomaticRestartSignOn':
    path   => 'HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableAutomaticRestartSignOn',
    type   => 'dword',
    data   => 1,
    notify => Exec['Reload Explorer'],
  }

  Registry_key['OpenWithNotepadKey']
  -> Registry_key['OpenWithNotepadCommandKey']
  -> Registry::Value['OpenWithNotepadCommandValue']

  # Disable web search results in the start menu
  # https://superuser.com/questions/1196618/how-to-disable-internet-search-results-in-start-menu-post-creators-update/1325836#1325836
  # Watch out for https://winaero.com/disable-web-search-in-taskbar-in-windows-10-version-2004/
  hkcu { 'BindSearchEnabled':
    key   => 'Software\Microsoft\Windows\CurrentVersion\Search',
    value => 'BingSearchEnabled',
    data  => 0,
  }

  hkcu { 'AllowSearchToUseLocation':
    key   => 'Software\Microsoft\Windows\CurrentVersion\Search',
    value => 'AllowSearchToUseLocation',
    data  => 0,
  }

  hkcu { 'CortanaConsent':
    key   => 'Software\Microsoft\Windows\CurrentVersion\Search',
    value => 'CortanaConsent',
    data  => 0,
  }

  # https://www.windowscentral.com/how-disable-recent-files-and-locations-jump-lists-windows-10
  hkcu { 'Start_TrackDocs':
    key   => 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced',
    value => 'Start_TrackDocs',
    data  => 0,
  }

  # https://www.howtogeek.com/331361/how-to-remove-the-3d-objects-folder-from-this-pc-on-windows-10/
  # https://superuser.com/questions/949218/how-to-customize-windows-10-6-folders-in-my-computer
  $namespace_uuids = [
    '0DB7E03F-FC29-4DC6-9020-FF41B59E513A', # 3D Objects
    '3dfdf296-dbec-4fb4-81d1-6a3438bcf4de', # Music
    'f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a', # Videos
  ]
  $namespace_uuids.each |$namespace_uuid| {
    registry_key { "Microsoft-${namespace_uuid}":
      path   => "HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{${namespace_uuid}}",
      ensure => absent,
    }
    registry_key { "Wow64-${namespace_uuid}":
      path   => "HKLM\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{${namespace_uuid}}",
      ensure => absent,
    }
  }

  # This is being recorded for documentation purposes.
  # https://www.virtualbox.org/ticket/19365
  # hkcu { 'DisableTransparency':
  #   key   => 'SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize',
  #   value => 'EnableTransparency',
  #   data  => 0,
  # }

  exec { 'Reload Explorer':
    command     => "Stop-Process -ProcessName explorer",
    refreshonly => true,
  }
}
