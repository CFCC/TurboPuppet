param(
  [string]$Distro = 'Ubuntu',

  [Parameter(Mandatory = $true)]
  [string]$CamperUsername
)

$ErrorActionPreference = 'Stop'

function Test-FeatureEnabled {
  param([string]$FeatureName)
  (Get-WindowsOptionalFeature -Online -FeatureName $FeatureName | Select-Object -ExpandProperty State) -eq 'Enabled'
}

function Invoke-DismEnable {
  param([string]$FeatureName)

  & dism.exe /online /enable-feature /featurename:$FeatureName /all /norestart | Out-Default
  $rc = $LASTEXITCODE
  if ($rc -ne 0 -and $rc -ne 3010) {
    throw "Failed enabling feature $FeatureName (exit $rc)"
  }
  return $rc
}

function Test-DistroPresent {
  param([string]$Name)
  (wsl.exe -l -q 2>$null) -contains $Name
}

function Test-DefaultVersionIs2 {
  $status = wsl.exe --status 2>$null
  $null -ne ($status | Select-String -Pattern 'Default Version:\s+2')
}

function Test-WslCoreReady {
  $statusText = (& wsl.exe --status 2>&1 | Out-String)
  if ($LASTEXITCODE -eq 0) {
    return $true
  }

  # Transitional state: features may be enabled but WSL is not ready until reboot.
  if ($statusText -match 'Windows Subsystem for Linux is not installed') {
    return $false
  }

  return $false
}

function Ensure-WslCoreInstalled {
  # Newer WSL supports --no-distribution; older builds may not.
  & wsl.exe --install --no-distribution | Out-Default
  $rc = $LASTEXITCODE
  if ($rc -eq 0 -or $rc -eq 3010) {
    return $rc
  }

  & wsl.exe --install | Out-Default
  $rc = $LASTEXITCODE
  if ($rc -eq 0 -or $rc -eq 3010) {
    return $rc
  }

  throw "Failed installing WSL core (exit $rc)"
}

function Test-RebootPending {
  $cbsPending = Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending'
  $wuPending = Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'
  $pendingRename = $null -ne (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name PendingFileRenameOperations -ErrorAction SilentlyContinue)
  $cbsPending -or $wuPending -or $pendingRename
}

try {
  $featuresChanged = $false

  $wslEnabled = Test-FeatureEnabled -FeatureName 'Microsoft-Windows-Subsystem-Linux'
  $vmEnabled = Test-FeatureEnabled -FeatureName 'VirtualMachinePlatform'

  if (-not $wslEnabled) {
    $rc = Invoke-DismEnable -FeatureName 'Microsoft-Windows-Subsystem-Linux'
    $featuresChanged = $true
  }

  if (-not $vmEnabled) {
    $rc = Invoke-DismEnable -FeatureName 'VirtualMachinePlatform'
    $featuresChanged = $true
  }

  if ($featuresChanged) {
    Write-Output 'WSL prerequisites changed. Reboot Windows, then run puppet again to finish Ubuntu setup.'
    exit 3010
  }

  if (Test-RebootPending) {
    Write-Output 'Windows reports a pending reboot. Reboot Windows, then run puppet again to continue WSL setup.'
    exit 3010
  }

  if (-not (Test-WslCoreReady)) {
    $coreInstallRc = Ensure-WslCoreInstalled
    if ($coreInstallRc -eq 3010) {
      Write-Output 'WSL core install requested a reboot. Reboot Windows, then run puppet again to continue setup.'
      exit 3010
    }

    if (-not (Test-WslCoreReady)) {
      Write-Output 'WSL core is still not ready. Reboot Windows, then run puppet again to continue setup.'
      exit 3010
    }
  }

  if (-not (Test-DefaultVersionIs2)) {
    & wsl.exe --set-default-version 2 | Out-Default
    if ($LASTEXITCODE -ne 0) {
      if ((Test-RebootPending) -or (-not (Test-WslCoreReady))) {
        Write-Output 'WSL default version update is blocked by pending reboot. Reboot Windows, then run puppet again.'
        exit 3010
      }
      throw "Failed setting WSL default version to 2 (exit $LASTEXITCODE)"
    }
  }

  if (-not (Test-DistroPresent -Name $Distro)) {
    & wsl.exe --install -d $Distro | Out-Default
    if ($LASTEXITCODE -eq 3010) {
      Write-Output 'Ubuntu install requested a reboot. Reboot Windows, then run puppet again.'
      exit 3010
    }
    if ($LASTEXITCODE -ne 0) {
      if (Test-RebootPending) {
        Write-Output 'Ubuntu install is blocked by pending reboot. Reboot Windows, then run puppet again.'
        exit 3010
      }
      throw "Failed installing distro $Distro (exit $LASTEXITCODE)"
    }
  }

  if (Test-DistroPresent -Name $Distro) {
    $bootstrap = @"
id -u $CamperUsername >/dev/null 2>&1 || useradd --create-home --user-group --groups sudo $CamperUsername
echo '[user]' > /etc/wsl.conf
echo 'default=$CamperUsername' >> /etc/wsl.conf
"@
    & wsl.exe -d $Distro -u root -- bash -lc $bootstrap | Out-Default
    if ($LASTEXITCODE -ne 0) {
      throw "Failed configuring WSL user bootstrap (exit $LASTEXITCODE)"
    }

    & wsl.exe --shutdown | Out-Null
  }

  exit 0
} catch {
  Write-Error $_
  exit 1
}
