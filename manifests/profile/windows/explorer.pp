#
# Tweaks to Explorer.exe
#
class profile::windows::explorer {
    # We want to preserve the "RunAsAdministrator" bit.
    # https://stackoverflow.com/questions/28997799/how-to-create-a-run-as-administrator-shortcut-using-powershell
    file { "C:/Users/${site::cfcc::camper_username}/Desktop/sudo cmd.lnk":
        source => 'puppet:///modules/cfcc/sudocmd.lnk',
    }

    # Remove built-in shortcut files that are useless
    $junk_shortcuts = [
        "C:/Users/${site::cfcc::camper_username}/Desktop/Windows 10 Update Assistant.lnk",
        "C:/Users/Public/Desktop/3D Vision Photo Viewer.lnk"
    ]
    file { $junk_shortcuts: ensure => absent }

    # Hidden files and file extensions
    # The Puppet Registry provider does not support HKCU. RIP...
    # registry_value { 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Hidden':
    #     ensure => present,
    #     type   => dword,
    #     data   => 1
    # }
    #
    # registry_value { 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\HideFileExt':
    #     ensure => present,
    #     type   => dword,
    #     data   => 0
    # }

    $extensions_key = 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    $extensions_value = 'HideFileExt'
    $extensions_data = 0
    exec { 'ShowFileExtensions':
        command => "Set-ItemProperty -Path ${extensions_key} -Name ${extensions_value} ${extensions_data}",
        onlyif  => psexpr("((Get-ItemProperty -Path ${extensions_key} -Name ${extensions_value} | Select -ExpandProperty ${extensions_value}) -ne ${extensions_data})"),
        notify  => Exec['Reload Explorer']
    }

    $show_hidden_files_key = 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    $show_hidden_files_value = 'Hidden'
    $show_hidden_files_data = 1
    exec { 'ShowHiddenFiles':
        command => "Set-ItemProperty -Path ${show_hidden_files_key} -Name ${show_hidden_files_value} ${show_hidden_files_data}",
        onlyif  => psexpr("((Get-ItemProperty -Path ${show_hidden_files_key} -Name ${show_hidden_files_value} | Select -ExpandProperty ${show_hidden_files_value}) -ne ${show_hidden_files_data})"),
        notify  => Exec['Reload Explorer']
    }

    # https://www.askvg.com/how-to-remove-search-and-task-view-icons-from-windows-10-taskbar/
    $cortana_search_key = 'HKCU:Software\Microsoft\Windows\CurrentVersion\Search'
    $cortana_search_value = 'SearchboxTaskbarMode'
    $cortana_search_data = 0
    exec { 'DisableCortanaSearch':
        command => "Set-ItemProperty -Path ${cortana_search_key} -Name ${cortana_search_value} ${cortana_search_data}",
        onlyif  => psexpr("((Get-ItemProperty -Path ${cortana_search_key} -Name ${cortana_search_value} | Select -ExpandProperty ${cortana_search_value}) -ne ${cortana_search_data})"),
        notify  => Exec['Reload Explorer']
    }

    $taskview_button_key = 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    $taskview_button_value = 'ShowTaskViewButton'
    $taskview_button_data = 0
    exec { 'DisableTaskview':
        command => "Set-ItemProperty -Path ${taskview_button_key} -Name ${taskview_button_value} ${taskview_button_data}
            ",
        onlyif  => psexpr("((Get-ItemProperty -Path ${taskview_button_key} -Name ${taskview_button_value}
             | Select -ExpandProperty ${taskview_button_value}) -ne ${taskview_button_data})"),
        notify  => Exec['Reload Explorer']
    }

    $people_bar_key = 'HKCU:Software\Policies\Microsoft\Windows\Explorer'
    $people_bar_value = 'HidePeopleBar'
    $people_bar_data = 1

    # Test-Path returns False if nonexistant, True if existant
    exec { 'CreatePeopleBarKey':
        command => "New-Item -Path ${people_bar_key} -Name Explorer",
        unless  => psexpr("(Test-Path -Path ${people_bar_key})")
    }

    exec { 'DisablePeopleBar':
        command => "Set-ItemProperty -Path ${people_bar_key} -Name ${people_bar_value} ${people_bar_data}",
        onlyif  => psexpr("((Get-ItemProperty -Path ${people_bar_key} -Name ${people_bar_value} | Select -ExpandProperty ${people_bar_value}) -ne ${people_bar_data})"),
        notify  => Exec['Reload Explorer']
    }

    exec { 'Reload Explorer':
        command     => "Stop-Process -ProcessName explorer",
        refreshonly => true,
    }

    Exec['CreatePeopleBarKey'] -> Exec['DisablePeopleBar']

    # Mail
    # get-appxpackage *microsoft.windowscommunicationsapps* | remove-appxpackage
    # REG DELETE HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband /F
    $taskband_key = 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband'
    $taskband_value = 'Favorites'
    $taskband_data = 255

    # Test-Path returns False if nonexistant, True if existant
    exec { 'DeleteTaskband':
        command => "Set-ItemProperty -Path ${taskband_key} -Name ${taskband_value} ${taskband_data}",
        onlyif  => psexpr("((Get-ItemProperty -Path ${taskband_key} -Name ${taskband_value} | Select -ExpandProperty ${taskband_value}) -ne ${taskband_data})"),
        notify  => Exec['Reload Explorer']
    }
}
