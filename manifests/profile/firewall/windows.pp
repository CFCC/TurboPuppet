#
# Base Firewall class for Windows. Only generic things should be specified
# here.
#
class profile::firewall::windows {
    # There is a bug that prevents state checking.
    # https://github.com/voxpupuli/puppet-windows_firewall/issues/23
    # It is most unfortunate. If the rule gets disabled there is nothing
    # that we can do about it here.

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

    # This will exec on every run if Miracast is enabled. It causes multiple
    # networks to appear in the results of the Get- which doesn't match.
    exec { 'SetConnectionPolicy':
        command  => 'Set-NetConnectionProfile -NetworkCategory Private',
        onlyif   => psexpr("((Get-NetConnectionProfile | select -ExpandProperty NetworkCategory) -ne 'Private')"),
    }

    Exec['SetConnectionPolicy'] -> Windows_firewall::Exception['Allow-ICMPv4']
}
