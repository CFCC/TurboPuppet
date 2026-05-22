#
# Manages a macOS defaults(1) key-value pair.
# Supports simple scalar types: -int, -float, -string.
# Note: -bool values are stored as 1/0 by defaults(1); pass '1' or '0' as
# $value (not 'true'/'false') so the unless check compares correctly.
#
define cfcc::osx_defaults (
  $domain,
  $key,
  $value  = undef,
  $type   = 'int',
  $ensure = present,
  $user   = undef,
) {
  $defaults_bin = '/usr/bin/defaults'
  $sudo_prefix  = $user ? { undef => '', default => "/usr/bin/sudo -u ${user} " }

  if $ensure == present {
    if $value == undef {
      fail('cfcc::osx_defaults: value must be set when ensure => present')
    }

    $type_flag = " -${type}"

    exec { "osx_defaults-${name}":
      command => "${sudo_prefix}${defaults_bin} write '${domain}' '${key}'${type_flag} ${value}",
      unless  => "/bin/sh -c \"${sudo_prefix}${defaults_bin} read '${domain}' '${key}' 2>/dev/null | /usr/bin/grep -qxF '${value}'\"",
      path    => ['/usr/bin', '/bin'],
    }
  } else {
    exec { "osx_defaults-${name}":
      command => "${sudo_prefix}${defaults_bin} delete '${domain}' '${key}'",
      onlyif  => "/bin/sh -c \"${sudo_prefix}${defaults_bin} read '${domain}' '${key}' 2>/dev/null\"",
      path    => ['/usr/bin', '/bin'],
    }
  }
}
