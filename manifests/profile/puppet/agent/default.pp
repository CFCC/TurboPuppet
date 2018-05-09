#
#
#
class profile::puppet::agent::default inherits profile::puppet::agent {
    # We don't want Puppet coming in and doing things while campers are working.
    # So we will disable it and deal with it manually.
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