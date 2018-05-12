#
# Default config for Puppet agent runtime. Every 30 minutes.
#
class profile::puppet::agent::default inherits profile::puppet::agent {
    service { $agent_service:
        ensure => 'running',
        enable => 'true'
    }

    $run_interval = '30m'
    file { 'PuppetAgentConfig':
        path    => $agent_config_file,
        content => template('cfcc/puppet/agent_disabled.conf.erb'),
    }
}