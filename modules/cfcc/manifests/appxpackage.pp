#
# AppxPackage Custom Resource
#
# @param ensure The desired state of the Appx package
# @param package_name The name of the Appx package to manage
#
define cfcc::appxpackage (
  Enum['present', 'absent'] $ensure,
  String $package_name = $name,
) {
  case $ensure {
    'present': {
      # @TODO this.
      fail('appxpackage present not supported yet')
    }
    'absent': {
      exec { "Remove-${name}":
        command => "Get-AppxPackage \"${package_name}\" | Remove-AppxPackage",
        onlyif  => cfcc::psexpr("(Get-AppxPackage \"${package_name}\" | Select -ExpandProperty Name) -eq \"${package_name}\""),
      }
    }
    default: {
      fail("Unsupported ensure for appxpackage (got ${ensure})")
    }
  }
}
