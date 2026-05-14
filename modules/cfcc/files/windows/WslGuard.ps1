param(
  [Parameter(Mandatory = $true)]
  [ValidateSet('RebootPending', 'PostReboot', 'BackfillNeeded', 'DefaultVersionNeedsSet', 'DistroMissingPostReboot', 'DistroPresentPostReboot')]
  [string]$Check,

  [Parameter(Mandatory = $true)]
  [string]$MarkerPath,

  [string]$Distro = 'Ubuntu'
)

function Test-MarkerExists {
  param([string]$Path)
  Test-Path -Path $Path
}

function Test-PostRebootSinceMarker {
  param([string]$Path)

  if (-not (Test-MarkerExists -Path $Path)) {
    return $false
  }

  $bootTime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime.ToUniversalTime()
  $markTime = (Get-Item -Path $Path).LastWriteTimeUtc
  return ($bootTime -gt $markTime)
}

function Test-WindowsFeatureEnabled {
  param([string]$FeatureName)

  try {
    return ((Get-WindowsOptionalFeature -Online -FeatureName $FeatureName | Select-Object -ExpandProperty State) -eq 'Enabled')
  } catch {
    return $false
  }
}

function Test-DistroPresent {
  param([string]$Name)

  try {
    return ((wsl.exe -l -q 2>$null) -contains $Name)
  } catch {
    return $false
  }
}

function Test-DefaultVersionIs2 {
  try {
    $status = wsl.exe --status 2>$null
    return ($null -ne ($status | Select-String -Pattern 'Default Version:\s+2'))
  } catch {
    return $false
  }
}

$markerExists = Test-MarkerExists -Path $MarkerPath
$postReboot = Test-PostRebootSinceMarker -Path $MarkerPath
$rebootPending = $markerExists -and -not $postReboot
$distroPresent = Test-DistroPresent -Name $Distro

$result = switch ($Check) {
  'RebootPending'           { $rebootPending }
  'PostReboot'              { $postReboot }
  'BackfillNeeded'          { (-not $markerExists) -and (Test-WindowsFeatureEnabled -FeatureName 'Microsoft-Windows-Subsystem-Linux') -and (Test-WindowsFeatureEnabled -FeatureName 'VirtualMachinePlatform') -and (-not $distroPresent) }
  'DefaultVersionNeedsSet'  { $postReboot -and (-not (Test-DefaultVersionIs2)) }
  'DistroMissingPostReboot' { $postReboot -and (-not $distroPresent) }
  'DistroPresentPostReboot' { $postReboot -and $distroPresent }
  default                   { $false }
}

if ($result) {
  exit 0
}

exit 1
