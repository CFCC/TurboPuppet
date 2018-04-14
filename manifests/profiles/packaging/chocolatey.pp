#
# Setup Chocolatey package system.
# NOTE - to install packages you need to set provider => chocolatey on your
# Package resources. This can be done easily by taking advantage
# of the profile::windows inherit. See that class for details.
#
class profile::packaging::chocolatey {
    # Enable chocolatey
    class { 'chocolatey':

    }
}
