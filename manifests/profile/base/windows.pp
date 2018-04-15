#
# Simple tweaks to Windows to make it behave the way we want.
# These are NOT intended to be feature that make Windows/Puppet
# function.
#
class profile::base::windows {
    include profile::windows::explorer
    include profile::windows::power
}
