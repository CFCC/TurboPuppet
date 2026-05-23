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
  [Console]::WriteLine("[$ts] $Message")
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

function Write-ExecutionContext {
  $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $sessionId = (Get-Process -Id $PID).SessionId
  $sessionName = if ($env:SESSIONNAME) { $env:SESSIONNAME } else { '(unset)' }
  $isAdmin = Test-IsAdministrator
  Write-Log "Execution context: User=$($identity.Name) SID=$($identity.User.Value) SessionId=$sessionId SESSIONNAME=$sessionName UserInteractive=$([Environment]::UserInteractive) IsAdministrator=$isAdmin"
}

function Test-IsAdministrator {
  $principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Assert-RunningElevated {
  if (-not (Test-IsAdministrator)) {
    throw @(
      'WSL platform install requires an elevated Administrator session.'
      "Current user is $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)."
      'Re-run turbopuppet from an elevated Administrator PowerShell window (Run as administrator).'
    ) -join ' '
  }
}

function Invoke-Wsl {
  param([string[]]$Arguments)
  Invoke-NativeCommand -Command 'wsl.exe' -Arguments $Arguments
}

function Test-FeatureEnabled {
  param([string]$FeatureName)
  (Get-WindowsOptionalFeature -Online -FeatureName $FeatureName | Select-Object -ExpandProperty State) -eq 'Enabled'
}

function Assert-WslFeaturesEnabled {
  $wslEnabled = Test-FeatureEnabled -FeatureName 'Microsoft-Windows-Subsystem-Linux'
  $vmEnabled = Test-FeatureEnabled -FeatureName 'VirtualMachinePlatform'
  Write-Log "Feature status: WSL=$wslEnabled, VirtualMachinePlatform=$vmEnabled"

  if (-not $wslEnabled -or -not $vmEnabled) {
    throw 'WSL optional features are not enabled. Run turbopuppet -tags windowsupdate first (wsl::preflight), reboot, then run turbopuppet again.'
  }
}

function Test-DistroPresent {
  param([string]$Name)
  $result = Invoke-Wsl -Arguments @('-l', '-q')
  if ($result.ExitCode -ne 0) {
    return $false
  }
  $distros = $result.Output -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
  $distros -contains $Name
}

function Get-WslStatusResult {
  Invoke-Wsl -Arguments @('--status')
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
  return $statusResult.ExitCode -eq 0
}

function Test-WslUpdatePrompt {
  param([string]$Output)

  return (
    $Output -match 'Windows Subsystem for Linux must be updated to the latest version' -or
    $Output -match 'Press any key to install Windows Subsystem for Linux'
  )
}

function Ensure-WslCoreInstalled {
  $attempts = [System.Collections.Generic.List[hashtable]]::new()

  $initialStatus = Get-WslStatusResult
  Write-Log "wsl --status exit $($initialStatus.ExitCode)"
  Write-Output $initialStatus.Output

  if ($initialStatus.ExitCode -eq 0) {
    Write-Log 'WSL core is already ready'
    return 0
  }

  $commandLabel = 'wsl.exe --install --no-distribution --web-download'
  Write-Log "WSL core not ready (status exit $($initialStatus.ExitCode)), installing platform"

  $proc = Start-Process -FilePath 'wsl.exe' -ArgumentList '--install','--no-distribution','--web-download' -Wait -PassThru -NoNewWindow
  $result = @{
    ExitCode = $proc.ExitCode
    Output   = '(output not captured - requires console)'
  }
  Write-Log "Completed: wsl.exe --install (exit $($result.ExitCode))"
  $attempts.Add(@{
    Command  = $commandLabel
    ExitCode = $result.ExitCode
    Output   = $result.Output
  })

  if (Test-WslCoreReady) {
    Write-Log 'WSL core is ready after install'
    return 0
  }

  if ($result.ExitCode -eq 3010) {
    Write-Log 'WSL core install requested reboot'
    return 3010
  }

  if (Test-WslUpdatePrompt -Output $result.Output) {
    throw (Format-WslCoreFailure -Reason 'WSL core install triggered the interactive updater prompt' -InitialStatus $initialStatus -Attempts $attempts)
  }

  if (Test-RebootPending) {
    Write-Log 'WSL core install is blocked by pending reboot'
    return 3010
  }

  throw (Format-WslCoreFailure -Reason 'Failed installing WSL core' -InitialStatus $initialStatus -Attempts $attempts)
}

function Format-WslCoreFailure {
  param(
    [string]$Reason,
    [hashtable]$InitialStatus,
    [System.Collections.Generic.List[hashtable]]$Attempts
  )

  $initialStatusOutput = if ([string]::IsNullOrWhiteSpace($InitialStatus.Output)) { '(no output)' } else { $InitialStatus.Output }
  $attemptDetails = ($Attempts | ForEach-Object {
    $output = if ([string]::IsNullOrWhiteSpace($_.Output)) { '(no output)' } else { $_.Output }
    @(
      "  Command: $($_.Command)"
      "  Exit code: $($_.ExitCode)"
      "  Output:"
      ($output -split "`n" | ForEach-Object { "    $_" }) -join "`n"
    ) -join "`n"
  }) -join "`n`n"

  $currentStatus = Get-WslStatusResult
  $currentStatusOutput = if ([string]::IsNullOrWhiteSpace($currentStatus.Output)) { '(no output)' } else { $currentStatus.Output }

  return @(
    "$Reason (last exit $($Attempts[-1].ExitCode))."
    "Initial wsl --status (exit $($InitialStatus.ExitCode)):"
    ($initialStatusOutput -split "`n" | ForEach-Object { "  $_" }) -join "`n"
    'Attempted commands:'
    $attemptDetails
    "Current wsl --status (exit $($currentStatus.ExitCode)):"
    ($currentStatusOutput -split "`n" | ForEach-Object { "  $_" }) -join "`n"
  ) -join "`n"
}

function Test-RebootPending {
  $cbsPending = Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending'
  $wuPending = Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'
  $pendingRename = $null -ne (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name PendingFileRenameOperations -ErrorAction SilentlyContinue)
  $cbsPending -or $wuPending -or $pendingRename
}

try {
  Write-Log "Starting WSL installation for distro '$Distro', user '$CamperUsername'"
  Write-ExecutionContext
  Assert-RunningElevated

  Write-Log 'Verifying WSL optional features (preflight)...'
  Assert-WslFeaturesEnabled

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
    $result = Invoke-Wsl -Arguments @('--set-default-version', '2')
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
    Write-Log "Distro not found, installing '$Distro' with --no-launch --web-download..."
    $result = Invoke-Wsl -Arguments @('--install', '-d', $Distro, '--no-launch', '--web-download')
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
    $result = Invoke-Wsl -Arguments @('-d', $Distro, '-u', 'root', '--', 'bash', '-lc', $bootstrap)
    Write-Output $result.Output
    if ($result.ExitCode -ne 0) {
      throw "Failed configuring WSL user bootstrap (exit $($result.ExitCode))"
    }
    Write-Log "Bootstrap completed"

    Write-Log "Shutting down WSL..."
    $null = Invoke-Wsl -Arguments @('--shutdown')
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
