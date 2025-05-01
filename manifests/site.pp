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
