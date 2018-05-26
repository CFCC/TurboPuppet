#
# Portainer manager
# https://portainer.readthedocs.io/en/latest/deployment.html
#
class profile::portainer::local {
    docker::image { 'portainer/portainer': }

    docker_volume { 'portainer_data':
        ensure => present,
    }

    # This is not the right thing
    # docker::run { 'portainer':
    #     image            => 'portainer/portainer',
    #     detach           => true,
    #     ports            => ['9000:9000'],
    #     # expose           => ['9000'],
    #     volumes          => ['/var/run/docker.sock:/var/run/docker.sock', 'portainer_data:/data'],
    #     # extra_parameters => [ '--restart=always' ],
    #     service_prefix => '',
    # }

    Docker_volume['portainer_data'] -> Docker::Image['portainer/portainer']
    # -> Docker::Run['portainer']
}