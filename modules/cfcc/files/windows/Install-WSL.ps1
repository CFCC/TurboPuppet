param(
  [string]$Distro = 'Ubuntu',

  [Parameter(Mandatory = $true)]
  [string]$CamperUsername
)

$ErrorActionPreference = 'Stop'
# In PowerShell 7+, native command non-zero exit codes can be promoted to
# errors. We need to inspect WSL exit codes/output ourselves.
if ($null -ne (Get-Variable -Name PSNativeCommandUseErrorActionPreference -ErrorAction SilentlyContinue)) {
  $PSNativeCommandUseErrorActionPreference = $false
}

function Write-Log {
  param([string]$Message)
  $ts = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
  Write-Output "[$ts] $Message"
}

function Invoke-NativeCommand {
  param(
    [string]$Command,
    [string[]]$Arguments
  )
  $argString = $Arguments -join ' '
  Write-Log "Running: $Command $argString"
  $prevEAP = $ErrorActionPreference
  $ErrorActionPreference = 'Continue'
  try {
    $output = & $Command @Arguments 2>&1 | Out-String
    $result = @{
      ExitCode = $LASTEXITCODE
      Output   = $output.Trim()
    }
    Write-Log "Completed: $Command (exit $($result.ExitCode))"
    return $result
  } finally {
    $ErrorActionPreference = $prevEAP
  }
}

function Test-FeatureEnabled {
  param([string]$FeatureName)
  (Get-WindowsOptionalFeature -Online -FeatureName $FeatureName | Select-Object -ExpandProperty State) -eq 'Enabled'
}

function Invoke-DismEnable {
  param([string]$FeatureName)

  Write-Log "DISM: Enabling feature $FeatureName..."
  & dism.exe /online /enable-feature /featurename:$FeatureName /all /norestart | Out-Default
  $rc = $LASTEXITCODE
  Write-Log "DISM: Feature $FeatureName completed (exit $rc)"
  if ($rc -ne 0 -and $rc -ne 3010) {
    throw "Failed enabling feature $FeatureName (exit $rc)"
  }
  return $rc
}

function Test-DistroPresent {
  param([string]$Name)
  $result = Invoke-NativeCommand -Command 'wsl.exe' -Arguments @('-l', '-q')
  if ($result.ExitCode -ne 0) {
    return $false
  }
  $distros = $result.Output -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
  $distros -contains $Name
}

function Get-WslStatusResult {
  Invoke-NativeCommand -Command 'wsl.exe' -Arguments @('--status')
}

function Test-DefaultVersionIs2 {
  $statusResult = Get-WslStatusResult
  if ($statusResult.ExitCode -ne 0) {
    return $false
  }
  $null -ne ($statusResult.Output | Select-String -Pattern 'Default Version:\s+2')
}

function Test-WslCoreReady {
  $statusResult = Get-WslStatusResult
  if ($statusResult.ExitCode -eq 0) {
    return $true
  }

  # Transitional state: features may be enabled but WSL is not ready until reboot.
  if ($statusResult.Output -match 'Windows Subsystem for Linux is not installed') {
    return $false
  }

  return $false
}

function Test-WslUpdatePrompt {
  param([string]$Output)

  return (
    $Output -match 'Windows Subsystem for Linux must be updated to the latest version' -or
    $Output -match 'Press any key to install Windows Subsystem for Linux'
  )
}

function Test-WebDownloadUnsupported {
  param([string]$Output)

  return (
    $Output -match 'Invalid command line option.*web-download' -or
    $Output -match 'unrecognized.*web-download' -or
    $Output -match 'unknown.*web-download' -or
    ($Output -match 'Usage:' -and $Output -match '--update' -and $Output -notmatch '--web-download')
  )
}

function Ensure-WslCoreInstalled {
  Write-Log "Trying: wsl --update --web-download"
  $result = Invoke-NativeCommand -Command 'wsl.exe' -Arguments @('--update', '--web-download')
  Write-Output $result.Output
  $lastResult = $result

  if (Test-WslCoreReady) {
    Write-Log "WSL core is ready after web-download update"
    return 0
  }

  if (Test-WebDownloadUnsupported -Output $result.Output) {
    Write-Log "WSL update does not support --web-download, trying: wsl --update"
    $result = Invoke-NativeCommand -Command 'wsl.exe' -Arguments @('--update')
    Write-Output $result.Output
    $lastResult = $result

    if (Test-WslCoreReady) {
      Write-Log "WSL core is ready after update"
      return 0
    }
  }

  if ($lastResult.ExitCode -eq 3010) {
    Write-Log "WSL core update requested reboot"
    return 3010
  }

  if (Test-WslUpdatePrompt -Output $lastResult.Output) {
    throw "WSL core update triggered the interactive updater prompt. Run 'wsl.exe --update --web-download' manually, then run puppet again."
  }

  if (Test-RebootPending) {
    Write-Log "WSL core update is blocked by pending reboot"
    return 3010
  }

  throw "Failed updating WSL core (exit $($lastResult.ExitCode))"
}

function Test-RebootPending {
  $cbsPending = Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending'
  $wuPending = Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'
  $pendingRename = $null -ne (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name PendingFileRenameOperations -ErrorAction SilentlyContinue)
  $cbsPending -or $wuPending -or $pendingRename
}

try {
  Write-Log "Starting WSL installation for distro '$Distro', user '$CamperUsername'"
  $featuresChanged = $false

  Write-Log "Checking Windows optional features..."
  $wslEnabled = Test-FeatureEnabled -FeatureName 'Microsoft-Windows-Subsystem-Linux'
  $vmEnabled = Test-FeatureEnabled -FeatureName 'VirtualMachinePlatform'
  Write-Log "Feature status: WSL=$wslEnabled, VirtualMachinePlatform=$vmEnabled"

  if (-not $wslEnabled) {
    Write-Log "Enabling Microsoft-Windows-Subsystem-Linux feature..."
    $rc = Invoke-DismEnable -FeatureName 'Microsoft-Windows-Subsystem-Linux'
    $featuresChanged = $true
  }

  if (-not $vmEnabled) {
    Write-Log "Enabling VirtualMachinePlatform feature..."
    $rc = Invoke-DismEnable -FeatureName 'VirtualMachinePlatform'
    $featuresChanged = $true
  }

  if ($featuresChanged) {
    Write-Log "Features changed, reboot required"
    Write-Output 'WSL prerequisites changed. Reboot Windows, then run puppet again to finish Ubuntu setup.'
    exit 3010
  }

  Write-Log "Checking for pending reboot..."
  if (Test-RebootPending) {
    Write-Log "Reboot is pending"
    Write-Output 'Windows reports a pending reboot. Reboot Windows, then run puppet again to continue WSL setup.'
    exit 3010
  }

  Write-Log "Checking if WSL core is ready..."
  if (-not (Test-WslCoreReady)) {
    Write-Log "WSL core not ready, installing..."
    $coreInstallRc = Ensure-WslCoreInstalled
    Write-Log "WSL core install returned: $coreInstallRc"
    if ($coreInstallRc -eq 3010) {
      Write-Output 'WSL core install requested a reboot. Reboot Windows, then run puppet again to continue setup.'
      exit 3010
    }

    Write-Log "Re-checking WSL core readiness..."
    if (-not (Test-WslCoreReady)) {
      Write-Log "WSL core still not ready after install"
      Write-Output 'WSL core is still not ready. Reboot Windows, then run puppet again to continue setup.'
      exit 3010
    }
  }
  Write-Log "WSL core is ready"

  Write-Log "Checking WSL default version..."
  if (-not (Test-DefaultVersionIs2)) {
    Write-Log "Setting WSL default version to 2..."
    $result = Invoke-NativeCommand -Command 'wsl.exe' -Arguments @('--set-default-version', '2')
    Write-Output $result.Output
    if ($result.ExitCode -ne 0) {
      if ((Test-RebootPending) -or (-not (Test-WslCoreReady))) {
        Write-Log "Default version change blocked by pending reboot"
        Write-Output 'WSL default version update is blocked by pending reboot. Reboot Windows, then run puppet again.'
        exit 3010
      }
      throw "Failed setting WSL default version to 2 (exit $($result.ExitCode))"
    }
  }
  Write-Log "WSL default version is 2"

  Write-Log "Checking if distro '$Distro' is present..."
  if (-not (Test-DistroPresent -Name $Distro)) {
    Write-Log "Distro not found, installing '$Distro' with --no-launch to skip interactive setup..."
    $result = Invoke-NativeCommand -Command 'wsl.exe' -Arguments @('--install', '-d', $Distro, '--no-launch')
    Write-Output $result.Output
    if ($result.ExitCode -eq 3010) {
      Write-Log "Distro install requires reboot"
      Write-Output 'Ubuntu install requested a reboot. Reboot Windows, then run puppet again.'
      exit 3010
    }
    if ($result.ExitCode -ne 0) {
      if (Test-RebootPending) {
        Write-Log "Distro install blocked by pending reboot"
        Write-Output 'Ubuntu install is blocked by pending reboot. Reboot Windows, then run puppet again.'
        exit 3010
      }
      throw "Failed installing distro $Distro (exit $($result.ExitCode))"
    }
    Write-Log "Distro install completed"
  } else {
    Write-Log "Distro '$Distro' already present"
  }

  Write-Log "Checking if distro bootstrap is needed..."
  if (Test-DistroPresent -Name $Distro) {
    Write-Log "Running user bootstrap in WSL..."
    $bootstrap = @"
set -e
if ! id -u $CamperUsername >/dev/null 2>&1; then
  useradd --create-home --user-group --groups sudo $CamperUsername
fi
echo '[user]' > /etc/wsl.conf
echo 'default=$CamperUsername' >> /etc/wsl.conf
echo '$CamperUsername ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/$CamperUsername
chmod 440 /etc/sudoers.d/$CamperUsername
"@
    $result = Invoke-NativeCommand -Command 'wsl.exe' -Arguments @('-d', $Distro, '-u', 'root', '--', 'bash', '-lc', $bootstrap)
    Write-Output $result.Output
    if ($result.ExitCode -ne 0) {
      throw "Failed configuring WSL user bootstrap (exit $($result.ExitCode))"
    }
    Write-Log "Bootstrap completed"

    Write-Log "Shutting down WSL..."
    $null = Invoke-NativeCommand -Command 'wsl.exe' -Arguments @('--shutdown')
    Write-Log "WSL shutdown completed"
  }

  Write-Log "Closing WSL Settings app if running..."
  Stop-Process -Name 'wslsettings' -ErrorAction SilentlyContinue

  Write-Log "WSL installation completed successfully"
  exit 0
} catch {
  Write-Log "ERROR: $_"
  Write-Error $_
  exit 1
}
