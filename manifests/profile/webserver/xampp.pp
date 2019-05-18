#
#
#
class profile::webserver::xampp {
    $package_name = $::osfamily ? {
        'windows' => 'Bitnami-XAMPP',
        default   => fail('Unsupported OS')
    }

    # So normally I wouldn't auto-make rules. However it seems that
    # as part of the install httpd launches or does something. Also means
    # we need the rules before we have the package.
    windows_firewall::exception { 'Allow XAMPP HTTP':
        ensure       => present,
        direction    => 'in',
        action       => 'Allow',
        enabled      => 'yes',
        protocol     => 'TCP',
        local_port   => '80',
        remote_port  => 'any',
        # display_name => 'File and Printer Sharing (Echo Request - ICMPv4-In)',
        display_name => 'TurboPuppet XAMPP HTTP Allow',
        # description  => 'Echo Request messages are sent as ping requests to other nodes.',
        description  => 'Allow httpd',
        program      => 'C:\xampp\apache\bin\httpd.exe'
    } ->
    windows_firewall::exception { 'Allow XAMPP HTTPS':
        ensure       => present,
        direction    => 'in',
        action       => 'Allow',
        enabled      => 'yes',
        protocol     => 'TCP',
        local_port   => '443',
        remote_port  => 'any',
        # display_name => 'File and Printer Sharing (Echo Request - ICMPv4-In)',
        display_name => 'TurboPuppet XAMPP HTTPS Allow',
        # description  => 'Echo Request messages are sent as ping requests to other nodes.',
        description  => 'Allow httpd',
        program      => 'C:\xampp\apache\bin\httpd.exe'
    } ->
    package { $package_name: }
}
