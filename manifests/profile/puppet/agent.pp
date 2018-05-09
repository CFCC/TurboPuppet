#
#
#
class profile::puppet::agent {
    $agent_config_file = $::osfamily ? {
        'windows' => 'C:\ProgramData\PuppetLabs\puppet\etc\puppet.conf',
        default   => fail('Unsupported OS')
    }
    $agent_service = $::osfamily ? {
        'windows' => 'puppet',
        default   => fail('Unsupported OS')
    }

    $puppet_master = $::site::cfcc::puppet_master

    File {
        notify => [Service[$agent_service]]
    }
}