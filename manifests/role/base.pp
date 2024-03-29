#
# Base role that sets defaults across ALL nodes.
# You CANNOT include anything that depends on a turbosite variable since
# those get evaluated later on.
#
class role::base {
  tag 'windowsupdate'

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
      include profile::packaging::psmodule
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

  # Very common Puppet stuff.
  # Note: Site has not been evaluated yet so you cannot include anything
  # that requires site such as mountpoints.
  include profile::packaging::packages

  # Drivers
  # https://puppet.com/docs/puppet/5.3/lang_data_regexp.html
  if $::hostname =~ /(?i:zotac)/  { include profile::driver::zotac }
  if $::hostname =~ /(?i:zaktop)/ { include profile::driver::zaktop }
  if $::hostname =~ /(?i:hp)/     { include profile::driver::hp }
}
