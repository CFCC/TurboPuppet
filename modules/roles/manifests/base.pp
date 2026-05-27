#
# Base role that sets defaults across ALL nodes.
# You CANNOT include anything that depends on a turbosite variable since
# those get evaluated later on.
#
class roles::base {
  tag 'windowsupdate'

  # Platform base
  case $facts['os']['family'] {
    'windows': {
      # This is where we specify defaults that automatically apply to ALL
      # resources in child classes. These can be overridden as needed.
      Package {
        provider => chocolatey,
        ensure   => present,
      }
      Exec {
        provider => powershell,
      }

      # Any custom providers or whatnot that we just specified as
      # the defaults should probably have a profile setting them up.
      contain profiles::packaging::chocolatey
      contain profiles::packaging::psmodule
      include profiles::powershell::executionpolicy::unrestricted
    }
    # 'Fedora': {
    #   # Nothing yet since Linux is sane!
    #   Package {
    #     ensure => present,
    #   }

    #   include profiles::packaging::yum
    # }
    # 'FreeBSD': {
    #   Package {
    #     ensure   => present,
    #     provider => pkgng,
    #   }
    # }
    'Darwin': {
      Package {
        provider => homebrew
      }

      # See notes in Windows above for more details on this stuff
      contain profiles::packaging::homebrew
    }
    default: {
      fail("platform ${facts['os']['family']} is unsupported")
    }
  }

  # Very common Puppet stuff.
  # Note: Site has not been evaluated yet so you cannot include anything
  # that requires site such as mountpoints.
  include profiles::packaging::packages
  include profiles::puppet::turbopuppet

  # Drivers
  # https://puppet.com/docs/puppet/5.3/lang_data_regexp.html
  if $facts['networking']['hostname'] =~ /(?i:zotac)/   { include profiles::driver::zotac }
  if $facts['networking']['hostname'] =~ /(?i:zaktop)/  { include profiles::driver::zaktop }
  if $facts['networking']['hostname'] =~ /(?i:hp)/      { include profiles::driver::hp }
  if $facts['networking']['hostname'] =~ /(?i:atom)/    { include profiles::driver::atomman }
  if $facts['networking']['hostname'] =~ /(?i:beelink)/ { include profiles::driver::beelink }
  if $facts['networking']['hostname'] =~ /(?i:gmk)/     { include profiles::driver::gmktec }
}
