# Site.pp is used for literally everything. Use with caution.

# The PS expression "('Foo' -eq 'Foo')" returns True. Conversely, 
# "('Foo' -ne 'Foo')" returns False. When cast to an integer
# (prefix the expression with [int]) this gets a bit more fun.
# False -> 0, True -> 1. However when running simply that
# expression in a PS shell the return code is always 0 (success).
# The return value (0, 1) is what we actually care about.
#
# The Puppet onlyif argument will allow an exec{} to run only when
# a test command returns 0. We can use the 'exit' command
# to have the PS interpreter take our return value and use
# that as the exit code instead. This gets us a return code
# pattern of:
# False/0 -> 0
# True/1  -> 1
#
# This now gets confusing. If we look at a sample test command
# of "exit [int]('Foo' -eq 'Foo')", this returns 1 (True). Except
# when read in the context of onlyif, the logic reads as:
#   "Run my command only if 'Foo' equals 'Foo'.
#
# Which doesn't exactly jive if the command is to say set a
# property or something. A la
#   "Set a network to Private only if the network is currently Private"
# That's a bit backwards. In this case I want the command to set only
# if the network is currently NOT Private. Something like:
#   "Set network to Private only if network is currently NOT private"
# But when we evaluate "exit [int]('Private' -ne 'Private')"
# we get False/0, which the test believe is success so the command runs.
# Similarly "exit [int]('Foobar' -ne 'Private')" is True/1 which the test
# belives failed so it does not trigger the command to run.
#
# It'd be really hot if we can invert the meaning of 0 and 1 in Puppet's
# return interpretation but alas we cannot. So can we do that in
# Powershell? Yes! RC=0 always evaluates to Success (aka run the command)
# and any other value will evaluate to fail (aka don't run the command).
# So we if subtract 1 from our return codes we get:
# False/0 -> -1
# True/1  -> 0
# In an expression this looks like "exit [int]('Foo' -ne 'Foo') - 1".
# It's kinda gross, but it works.
function psexpr (
  String $input
) >> String {
  $expression = "exit [int](${input}) - 1"

  # Return
  $expression
}

# This resource will create HKCU registry entries. You can't use the regular
# registry_key and registry_value resources because you don't necessarily control
# who the current user is. In our case, we do.
# @TODO to pass in a string of data you have to put quotes in the value, ie
# '"lolz"'. Otherwise you get a Powershell error hidden unless youre in debug
# mode. Apparently I only ever set numbers....
define hkcu (
  $key,
  $value,
  $data   = undef,
  $ensure = present
) {
  $formatted_key = "HKCU:${key}"

  if ($ensure == 'present') {
    if ($data == undef) {
      fail('data must be defined')
    }
    # Test-Path returns False if nonexistant, True if existant
    exec { "Create-${name}":
      command => "New-Item -Path ${formatted_key}",
      unless  => psexpr("Test-Path -Path ${formatted_key}")
    }

    exec { "Set-${name}":
      command => "Set-ItemProperty -Path ${formatted_key} -Name \"${value}\" ${data}",
      onlyif  => psexpr("(Get-ItemProperty -Path ${formatted_key} -Name \"${value}\" | Select -ExpandProperty \"${value}\") -ne ${data}"),
    }

    Exec["Create-${name}"] -> Exec["Set-${name}"]
  }
  else {
    exec { "Remove-${name}":
      command => "Remove-ItemProperty -Path ${formatted_key} -Name \"${value}\"",
      onlyif  => psexpr("Get-ItemProperty -Path ${formatted_key} -Name \"${value}\""),
    }
  }
}

# AppxPackage Custom Resource
define appxpackage (
  String $package_name = $name,
  Enum['present', 'absent'] $ensure,
) {
  case $ensure {
    'present': {
      # @TODO this.
      fail("appxpackage present not supported yet")
    }
    'absent': {
      exec { "Remove-${name}":
        command => "Get-AppxPackage \"${package_name}\" | Remove-AppxPackage",
        onlyif  => psexpr("(Get-AppxPackage \"${package_name}\" | Select -ExpandProperty Name) -eq \"${package_name}\"")
      }
    }
    default: {
      fail("Unsupported ensure for appxpackage (got ${ensure})")
    }
  }
}

# This creates a .desktop file for any given app. Pretty simple.
define freedesktop::shortcut (
  $path        = "/usr/local/share/applications/${name}.desktop",
  $ensure      = 'present',
  $version     = 1.0,
  $type        = 'Application',
  $displayname = $name,
  $exec,
  $icon        = '',
  $comment     = '',
  $categories  = [],
  $terminal    = false,
) {
  file { "${name}-Shortcut":
    path    => $path,
    ensure  => $ensure,
    content => template('cfcc/freedesktop/shortcut.erb'),
    mode    => '0755',
  }
}

# I'm not sure if the XDG_RUNTIME_DIR environment will magically work
# for all dconf commands. But at least for the clock it's the only one
# that is needed to make it work in real time. dbus-launch breaks it.
# Without the XDG var, the changes don't happen until you reboot.
# A restart of Cinnamon doesn't seem sufficient.
define dconf::setting (
  $key,
  $value,
  $user,
  $uid
) {
  # Format the value a bit
  # @TODO deprecated in Puppet6?
  # @TODO add more logic here as needed
  if is_string($value) {
    if ($value == 'true' or $value == 'false') {
      $raw_value = "'${value}'"
    }
    elsif ('uint64' in $value or 'uint32' in $value) {
      $raw_value = "'${value}'"
    }
    else {
      $raw_value = "\"'${value}'\""
    }
  }
  else {
    # This is basically just integers I think...
    $raw_value = $value
  }

  exec { "set-${name}":
    command     => "/usr/bin/dconf write ${key} ${raw_value}",
    onlyif      => "/usr/bin/test -z $(dconf read ${key}) || /usr/bin/test $(/usr/bin/dconf read ${key}) != ${raw_value}",
    environment => [
      "XDG_RUNTIME_DIR=/run/user/${uid}"
    ],
    user        => $user,
  }
}

# This is a convenience resource for dealing with Explorer Namespaces, which appears
# to be the term it uses for the major headings either in My Computer or on the Desktop.
# It's a pair of registry_key's but it can be obnoxious to always have to drop all of
# them.
define explorer_namespace_key (
  Enum['absent'] $ensure,
  String $uuid,
  Enum['MyComputer', 'Desktop'] $location,
) {
  # @TODO someday
}