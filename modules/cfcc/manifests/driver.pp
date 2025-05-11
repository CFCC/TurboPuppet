define cfcc::driver (
  $ensure = present,
  $path,
) {
  case $ensure {
    'present': {
      exec { "Install-${name}":
        command => "pnputil.exe /add-driver ${path} /install",
        unless  => cfcc::psexpr("pnputil.exe /enum-drivers | findstr /i \"${name}\""),
      }
    }
    'absent': {
      exec { "Remove-${name}":
        command => "pnputil.exe /delete-driver ${name} /force /uninstall",
        onlyif  => cfcc::psexpr("pnputil.exe /enum-drivers | findstr /i \"${name}\""),
      }
    }
  }
}
