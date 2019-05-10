#
#
#
class profile::time::client::macos {

    # Mac supports setting multiple, but not through systemsetup.
    # We could jam these in directly to the config file but it seems
    # that the system could mess that up if the dialog box does things.
    # https://www.ctrl.blog/entry/tutorial-macos-ntp-config.html
    $time_server = $turbosite::time_servers[0]

    # Timezone
    exec { 'Timezone':
        command => "/usr/sbin/systemsetup -settimezone ${turbosite::time_zone}",
        onlyif  => "/bin/test \"\$(/usr/sbin/systemsetup -gettimezone)\" != \"Time Zone: ${turbosite::time_zone}\""
    }
    # Use NTP
    exec { 'UseNetworkTime':
        command => '/usr/sbin/systemsetup -setusingnetworktime on',
        onlyif  => '/bin/test "$(/usr/sbin/systemsetup -getusingnetworktime)" != "Network Time: On"'
    }
    # NTP server
    exec { 'NetworkTimeServer':
        command => "/usr/sbin/systemsetup -setnetworktimeserver ${time_server}",
        onlyif  => "/bin/test \"\$(/usr/sbin/systemsetup -getnetworktimeserver)\" != \"Network Time Server: ${time_server}\""
    }
}
