#
# Master class for the Puppet Agent. This provides a common
# inheritance for subclasses that define the state of the
# Puppet agent (such as Default, Disabled, etc).
#
class profile::puppet::agent {
    $agent_config_file = $::kernel ? {
        'windows' => 'C:\ProgramData\PuppetLabs\puppet\etc\puppet.conf',
        'Linux'   => '/etc/puppetlabs/puppet/puppet.conf',
        'Darwin'  => '/etc/puppetlabs/puppet/puppet.conf',
        'FreeBSD' => '/usr/local/etc/puppet/puppet.conf',
        default   => fail('Unsupported OS')
    }
    $agent_service = $::kernel ? {
        default   => 'puppet'
    }

    $puppet_master = $turbosite::puppet_master

    File {
        notify => [Service[$agent_service]]
    }
}