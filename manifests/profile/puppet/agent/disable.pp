#
#
#
class profile::puppet::agent::disable inherits profile::puppet::agent {
    # We don't want Puppet coming in and doing things while campers are working.
    # So we will disable it and deal with it manually.
    service { $agent_service:
        ensure => 'stopped',
        enable => 'false'
    }

    $run_interval = '100y' # Bogus value to fill the space
    file { 'PuppetAgentConfig':
        path    => $agent_config_file,
        content => template('cfcc/puppet/agent_disabled.conf.erb'),
    }
}