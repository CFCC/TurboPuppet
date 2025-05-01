#
# Setup Homebrew package system.
# NOTE - to install packages you need to set provider => homebrew on your
# Package resources. This is done for you in role::base.
#
class profiles::packaging::homebrew {
  class { 'homebrew':
    user => lookup('camper_username'),
  }
}
