#
# Manages a macOS defaults(1) key-value pair.
# Supports simple scalar types: -int, -float, -string, -bool.
# For -bool, pass true/false; defaults(1) reads back 1/0 so the
# unless check translates automatically.
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

    # defaults read returns 1/0 for bools, so map true/false for the check
    $check_value = $type ? {
      'bool'  => $value ? { true => '1', 'true' => '1', default => '0' },
      default => $value,
    }

    exec { "osx_defaults-${name}":
      command => "${sudo_prefix}${defaults_bin} write '${domain}' '${key}'${type_flag} ${value}",
      unless  => "/bin/sh -c \"${sudo_prefix}${defaults_bin} read '${domain}' '${key}' 2>/dev/null | /usr/bin/grep -qxF '${check_value}'\"",
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
