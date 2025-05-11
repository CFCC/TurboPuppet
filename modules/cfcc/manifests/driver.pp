define cfcc::driver (
  $ensure = present,
  $path,
) {
  case $ensure {
    'present': {
      exec { "Install-${name}":
        command => "pnputil.exe /add-driver ${path} /install",
        unless  => cfcc::psexpr("pnputil.exe /enum-drivers | findstr /i \"${name}\""),
        # https://learn.microsoft.com/en-us/windows-hardware/drivers/devtest/pnputil-return-values
        returns => [
          0, # Success
          # 259, # Nothing on this system has the driver
          3010, # Success, restart required
        ],
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
