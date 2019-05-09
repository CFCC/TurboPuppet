#
# Setup Homebrew package system.
# NOTE - to install packages you need to set provider => homebrew on your
# Package resources. This is done for you in role::base.
#
class profile::packaging::homebrew {
    class { 'homebrew':
        # @TODO turbosite isnt evaluated yet. Gotta refactor role::base and role::camper
        user => 'camper'
    }
}
