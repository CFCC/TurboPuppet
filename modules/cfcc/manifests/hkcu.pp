# This resource will create HKCU registry entries. You can't use the regular
# registry_key and registry_value resources because you don't necessarily control
# who the current user is. In our case, we do.
# @TODO to pass in a string of data you have to put quotes in the value, ie
# '"lolz"'. Otherwise you get a Powershell error hidden unless youre in debug
# mode. Apparently I only ever set numbers....
define cfcc::hkcu (
  $key,
  $value,
  $data   = undef,
  $ensure = present,
  $onlyif = undef,
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

    # This allows a custom value setting condition (such as if a particular value is set)
    # rather than the default of if the value is the intended value.
    $onlyif_real = $onlyif ? {
      undef => psexpr("(Get-ItemProperty -Path ${formatted_key} -Name \"${value}\" | Select -ExpandProperty \"${value}\") -ne \"${data}\""),
      default => $onlyif,
    }

    exec { "Set-${name}":
      command => "Set-ItemProperty -Path ${formatted_key} -Name \"${value}\" ${data}",
      onlyif  => $onlyif_real,
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
