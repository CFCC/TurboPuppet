#
#
#
class profile::webserver::xampp {
    $package_name = $::osfamily ? {
        'windows' => 'Bitnami-XAMPP',
        default   => fail('Unsupported OS')
    }

    package { $package_name: }

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
    }
}
