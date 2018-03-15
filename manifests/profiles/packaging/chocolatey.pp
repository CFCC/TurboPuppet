#
# Setup Chocolatey package system.
# NOTE - to install packages you need to set provider => chocolatey on your
# Package resources.
#
class profiles::packaging::chocolatey {
    # Enable chocolatey
    class { 'chocolatey':

    }
}
