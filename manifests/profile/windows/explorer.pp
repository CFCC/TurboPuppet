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

    exec { 'Reload Explorer':
        command     => "Stop-Process -ProcessName explorer",
        refreshonly => true,
    }
}