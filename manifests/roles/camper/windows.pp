#
# Base class for all camper windows machines.
#
class roles::camper::windows {
    # This is where we specify defaults that automatically apply to ALL
    # package{} resources in child classes. These can be overridden
    # as needed.
    #
    # Windows requires the provider to be explicitly stated.
    Package {
        provider => chocolatey,
        ensure   => present,
    }
}