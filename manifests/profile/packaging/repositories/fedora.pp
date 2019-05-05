#
# Fedora package repositories
#
class profile::packaging::repositories::fedora {

    # Repositories are broken down into three (ok four) categories:
    # * system: Operating system vendor provided. Packages such as glibc, bash, low-level stuff like that.
    # * collections: Often 3rd party, giant repos of random stuff. RPMFusion, EPEL, etc.
    # * thirdparty: Single-tool specific repos for thing such as Steam, SublimeText, Chrome.
    # * internal: Custom repos built by us. We don't have any here yet.
    #
    # A class containing Virtual Resources for all of the repos in that category is included here.
    # By virtue of being a Virtual Resource, this does not mean that it is "realized" (aka created)
    # here. This we enter the ethereal realm of Puppet. Using a Resource Collector, aka "UFO Collector"
    # (flying-saucer looking thing a la:
    #   Yumrepo <| tag == 'yumrepo-system' |>
    # This will gather up all virtual resources with that specific tag and force them into existence.
    # WARNING: the flying saucer picks up from everything that matches the search!

    include profile::packaging::repositories::fedora::system
    include profile::packaging::repositories::fedora::thirdparty
    include profile::packaging::repositories::fedora::collections

    # Normally I'd say realize only the system category here and leave the rest to their
    # specific profiles. However, since we don't require that level of separation yet, they
    # will all be here and it can be assumed that any needed yum repo by any profile
    # will have that repo available.
    Yumrepo <| tag == 'yumrepo-system' |>
    Yumrepo <| tag == 'yumrepo-collections' |>
    Yumrepo <| tag == 'yumrepo-thirdparty' |>

    # In the model of profiles that would not rely on thirtparty repos being automatically
    # available, they would look something like the following:
    #
    # class profile::tool::slack {
    #     Yumrepo <| name == 'slack' |>
    #
    #     package { 'slack':
    #         ensure => latest,
    #         require => Yumrepo['slack']
    #     }
    #
    #     ...
    # }
    #
    # This way the Slack repo doesn't exist where it is not explicitly called for.
}
