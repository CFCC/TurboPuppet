#
#
#
class profile::windows::xbox::disable {
    # This didn't work
    # https://gist.github.com/joshschmelzle/04c57d957c5bb92e85ae9180021b26dc
    # Neither did this
    # https://www.reddit.com/r/Steam/comments/3jonwu/disable_windows_10_game_bar_via_registry/

    # But this did!
    # https://www.reddit.com/r/Windows10/comments/53xbef/game_bar_is_still_there_after_removing_xbox_app/
    registry_key { 'XboxGameDVRCurrentKey':
        path   => 'HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\ApplicationManagement\AllowGameDVR',
        ensure => present,
    }

    registry_value { 'XboxGameDVRCurrentValue': 
        path   => 'HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\ApplicationManagement\AllowGameDVR',
        ensure => present,
        type   => dword,
        data   => 0
    }

    registry_value { 'HKLM\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR\value':
        ensure => present,
        type   => dword,
        data   => 0
    }

    Registry_key['XboxGameDVRCurrentKey'] -> Registry_value['XboxGameDVRCurrentValue']
}
