#
# This class sets up Docker on a host.
#
class profile::docker::host {
    class { 'docker':
        version => 'latest'
    }
}