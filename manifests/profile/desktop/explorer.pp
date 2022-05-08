#
# Tweaks to Explorer.exe
#
class profile::desktop::explorer {
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
  Registry::Value {
    notify => Exec['Reload Explorer']
  }
  Registry_value {
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

  # Remove search bar from the taskbar
  # https://www.askvg.com/how-to-remove-search-and-task-view-icons-from-windows-10-taskbar/
  hkcu { 'SearchboxTaskbarMode':
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
    path => 'HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\HideSCAMeetNow',
    type => 'dword',
    data => 1,
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
    key   => 'HKCR\*\shell\Open with Notepad\command',
    value => '(default)',
    data  => 'notepad.exe %1',
  }

  # Disable re-opening programs after reboot
  # https://superuser.com/questions/1229963/windows-10-disable-reopening-programs-after-restart-startup
  registry_value { 'DisableAutomaticRestartSignOn':
    path => 'HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableAutomaticRestartSignOn',
    type => 'dword',
    data => 1,
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

  # Hide the Recycle Bin icon from the Desktop
  # https://www.computerhope.com/issues/ch001276.htm
  # $desktop_namespace_uuid = '645FF040-5081-101B-9F08-00AA002F954E'
  # These didn't work! Leaving for documentation just in case.
  # registry_key { "DesktopRecycleBinNamespaceKey":
  #   path   => "HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Desktop\\NameSpace\\{${desktop_namespace_uuid}}",
  #   ensure => absent,
  # }
  # registry_key { "Wow64-DesktopRecycleBinNamespaceKey":
  #   path   => "HKLM\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Desktop\\NameSpace\\{${desktop_namespace_uuid}}",
  #   ensure => absent,
  # }
  #
  # https://answers.microsoft.com/en-us/windows/forum/windows_10-files-winpc/recycle-bin-missing-in-win-10/8b34228e-a7b1-409b-8f31-31eedfc9c125
  # But this did!
  hkcu { 'HideRecycleBinDesktopIcon':
    key   => 'Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel',
    value => '{645FF040-5081-101B-9F08-00AA002F954E}',
    data  => 1,
  }


  # This is being recorded for documentation purposes.
  # https://www.virtualbox.org/ticket/19365
  # hkcu { 'DisableTransparency':
  #   key   => 'SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize',
  #   value => 'EnableTransparency',
  #   data  => 0,
  # }

  # Disable Cortana Things
  # https://winaero.com/hide-cortana-button-taskbar-windows-10/
  hkcu { 'ShowCortanaButton':
    key   => 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced',
    value => 'ShowCortanaButton',
    data  => 0,
  }

  # https://www.laptopmag.com/articles/turn-cortana-windows-10
  registry_key { 'WindowsSearch':
    path   => 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search',
    ensure => present,
  }
  registry_value { 'AllowCortana':
    path    => 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search\AllowCortana',
    type    => 'dword',
    data    => 0,
    require => Registry_key['WindowsSearch'],
  }

  # Disable News and Interests
  # https://www.prajwaldesai.com/disable-news-and-interests-in-windows-10/
  # I'm not sure this actually works
#  hkcu { 'ShellFeedsTaskbarViewMode':
#    key   => 'SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds',
#    value => 'ShellFeedsTaskbarViewMode',
#    data  => 2
#  }

  # https://winaero.com/add-or-remove-news-and-interests-button-from-taskbar-in-windows-10/
  registry_key { 'WindowsFeeds':
    path   => 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds',
    ensure => present,
  } ->
  registry_value { 'EnableFeeds':
    path => 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds\EnableFeeds',
    type => 'dword',
    data => 0
  }

  exec { 'Reload Explorer':
    command     => "Stop-Process -ProcessName explorer",
    refreshonly => true,
  }
}
