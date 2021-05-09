#
# Base role that sets defaults across ALL nodes.
#
class role::base {
  # Platform base
  case $::operatingsystem {
    'windows': {
      # This is where we specify defaults that automatically apply to ALL
      # resources in child classes. These can be overridden as needed.
      Package {
        provider => chocolatey,
        ensure   => present
      }
      Exec {
        provider => powershell
      }

      # Any custom providers or whatnot that we just specified as
      # the defaults should probably have a profile setting them up.
      include profile::packaging::chocolatey
      include profile::powershell::executionpolicy::unrestricted
    }
    'Fedora': {
      # Nothing yet since Linux is sane!
      Package {
        ensure => present
      }

      include profile::packaging::yum
    }
    'FreeBSD': {
      Package {
        ensure   => present,
        provider => pkgng
      }
    }
    'Darwin': {
      Package {
        provider => homebrew
      }

      # See notes in Windows above for more details on this stuff
      include profile::packaging::homebrew
      include profile::ide::xcode
    }
    default: {
      fail("platform ${::operatingsystem} is unsupported")
    }
  }

  # Very common Puppet stuff
  include profile::packaging::packages

  # Drivers
  # https://puppet.com/docs/puppet/5.3/lang_data_regexp.html
  if $::hostname =~ /(?i:zotac)/ { include profile::driver::zotac }
  if $::hostname =~ /(?i:zaktop)/ { include profile::driver::zaktop }
}
