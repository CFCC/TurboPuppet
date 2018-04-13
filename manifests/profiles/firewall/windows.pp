#
# To change the current network zone:
# - Helper Bar -> Network -> Click on Network -> Setting
#
class profiles::firewall::windows {
    windows_firewall::exception { 'Allow-ICMPv4':
        ensure       => present,
        direction    => 'in',
        action       => 'Allow',
        enabled      => 'yes',
        protocol     => 'ICMPv4',
        # local_port   => '5985',
        # remote_port  => 'any',
        # display_name => 'File and Printer Sharing (Echo Request - ICMPv4-In)',
        display_name => 'TurboPuppet ICMPv4 Allow',
        # description  => 'Echo Request messages are sent as ping requests to other nodes.',
        description  => 'Allow ping',
    }

    exec { 'SetConnectionPolicy':
        command  => 'Set-NetConnectionProfile -NetworkCategory Private',
        provider => 'powershell',
        # onlyif   => "(Get-NetConnectionProfile | select -ExpandProperty NetworkCategory) -ne 'Private'"
        # onlyif   => '(Get-NetConnectionProfile | select -ExpandProperty NetworkCategory) -ne \'Private\'',
        onlyif   => 'echo 0'
    }
}