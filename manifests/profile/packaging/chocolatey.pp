#
# Setup Chocolatey package system.
# NOTE - to install packages you need to set provider => chocolatey on your
# Package resources. This is done for you in role::base.
#
class profile::packaging::chocolatey {
    class { 'chocolatey': }
}
