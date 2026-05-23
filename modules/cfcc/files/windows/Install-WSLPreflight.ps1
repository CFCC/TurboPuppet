$ErrorActionPreference = 'Stop'

function Write-Log {
  param([string]$Message)
  $ts = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
  Write-Output "[$ts] $Message"
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

function Test-RebootPending {
  $cbsPending = Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending'
  $wuPending = Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'
  $pendingRename = $null -ne (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name PendingFileRenameOperations -ErrorAction SilentlyContinue)
  $cbsPending -or $wuPending -or $pendingRename
}

try {
  Write-Log 'Starting WSL preflight (optional features only)'
  $featuresChanged = $false

  Write-Log 'Checking Windows optional features...'
  $wslEnabled = Test-FeatureEnabled -FeatureName 'Microsoft-Windows-Subsystem-Linux'
  $vmEnabled = Test-FeatureEnabled -FeatureName 'VirtualMachinePlatform'
  Write-Log "Feature status: WSL=$wslEnabled, VirtualMachinePlatform=$vmEnabled"

  if (-not $wslEnabled) {
    Write-Log 'Enabling Microsoft-Windows-Subsystem-Linux feature...'
    $null = Invoke-DismEnable -FeatureName 'Microsoft-Windows-Subsystem-Linux'
    $featuresChanged = $true
  }

  if (-not $vmEnabled) {
    Write-Log 'Enabling VirtualMachinePlatform feature...'
    $null = Invoke-DismEnable -FeatureName 'VirtualMachinePlatform'
    $featuresChanged = $true
  }

  if ($featuresChanged) {
    Write-Log 'Features changed, reboot required'
    Write-Output 'WSL optional features enabled. Reboot Windows, then run puppet again to finish WSL setup.'
    exit 3010
  }

  Write-Log 'Checking for pending reboot...'
  if (Test-RebootPending) {
    Write-Log 'Reboot is pending'
    Write-Output 'Windows reports a pending reboot. Reboot Windows, then run puppet again to continue WSL setup.'
    exit 3010
  }

  Write-Log 'WSL preflight completed (optional features ready)'
  exit 0
} catch {
  Write-Log "ERROR: $_"
  Write-Error $_
  exit 1
}
