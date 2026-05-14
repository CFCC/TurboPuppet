param(
  [Parameter(Mandatory = $true)]
  [string]$MarkerPath,

  [string]$Distro = 'Ubuntu',

  [Parameter(Mandatory = $true)]
  [string]$CamperUsername
)

$ErrorActionPreference = 'Stop'

function Write-Marker {
  param([string]$Path)
  $dir = Split-Path -Path $Path -Parent
  if (-not (Test-Path -Path $dir)) {
    New-Item -Path $dir -ItemType Directory -Force | Out-Null
  }
  New-Item -Path $Path -ItemType File -Force | Out-Null
  Set-Content -Path $Path -Value (Get-Date -Format o)
}

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

try {
  $featuresChanged = $false
  $rebootRequired = $false

  $wslEnabled = Test-FeatureEnabled -FeatureName 'Microsoft-Windows-Subsystem-Linux'
  $vmEnabled = Test-FeatureEnabled -FeatureName 'VirtualMachinePlatform'

  if (-not $wslEnabled) {
    $rc = Invoke-DismEnable -FeatureName 'Microsoft-Windows-Subsystem-Linux'
    $featuresChanged = $true
    if ($rc -eq 3010) { $rebootRequired = $true }
  }

  if (-not $vmEnabled) {
    $rc = Invoke-DismEnable -FeatureName 'VirtualMachinePlatform'
    $featuresChanged = $true
    if ($rc -eq 3010) { $rebootRequired = $true }
  }

  if ($featuresChanged) {
    Write-Marker -Path $MarkerPath
    Write-Output 'WSL prerequisites changed. Reboot Windows, then run puppet agent -t again to finish Ubuntu setup.'
    exit 3010
  }

  $markerExists = Test-Path -Path $MarkerPath
  $postReboot = $false
  if ($markerExists) {
    $bootTime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime.ToUniversalTime()
    $markTime = (Get-Item -Path $MarkerPath).LastWriteTimeUtc
    $postReboot = $bootTime -gt $markTime

    if (-not $postReboot) {
      Write-Output 'WSL setup is waiting for reboot. Reboot Windows, then run puppet agent -t again.'
      exit 3010
    }
  }

  # Recovery path from historical partial runs.
  if (-not $markerExists -and (Test-FeatureEnabled -FeatureName 'Microsoft-Windows-Subsystem-Linux') -and (Test-FeatureEnabled -FeatureName 'VirtualMachinePlatform') -and -not (Test-DistroPresent -Name $Distro)) {
    Write-Marker -Path $MarkerPath
    Write-Output 'WSL features are enabled but distro setup is incomplete. Reboot Windows, then run puppet agent -t again.'
    exit 3010
  }

  if (-not (Test-DefaultVersionIs2)) {
    & wsl.exe --set-default-version 2 | Out-Default
    if ($LASTEXITCODE -ne 0) {
      throw "Failed setting WSL default version to 2 (exit $LASTEXITCODE)"
    }
  }

  if (-not (Test-DistroPresent -Name $Distro)) {
    & wsl.exe --install -d $Distro | Out-Default
    if ($LASTEXITCODE -eq 3010) {
      Write-Marker -Path $MarkerPath
      Write-Output 'Ubuntu install requested a reboot. Reboot Windows, then run puppet agent -t again.'
      exit 3010
    }
    if ($LASTEXITCODE -ne 0) {
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

  if (Test-Path -Path $MarkerPath) {
    Remove-Item -Path $MarkerPath -Force
  }

  if ($rebootRequired) {
    Write-Output 'WSL setup completed this run, but a reboot is still required.'
    exit 3010
  }

  exit 0
} catch {
  Write-Error $_
  exit 1
}
