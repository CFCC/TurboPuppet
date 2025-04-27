#!/usr/bin/env pwsh

# Constants
$ROOT_DIR = "C:\CampFitch"
$PUPPET_AGENT_VERSION = "8.10.0"
$PUPPET_MSI = "puppet-agent-$PUPPET_AGENT_VERSION-x64.msi"
$PUPPET_DOWNLOAD_URL = "https://downloads.puppetlabs.com/windows/puppet8/$PUPPET_MSI"
$INSTALLER_DIR = "$ROOT_DIR\opt\Installers"
$BIN_DIR = "$ROOT_DIR\bin"
$LOG_DIR = "$ROOT_DIR\logs"
$LOG_FILE = "$LOG_DIR\install-turbopuppet.log"

# Creates a directory and all parent directories if they don't exist.
function New-DirectorySafe {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    
    # Create the directory and all parent directories if they don't exist.
    # -Force will not error if the directory already exists.
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
}

# Writes output to both console and log file
function Write-Log {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('Info', 'Error')]
        [string]$Level = 'Info'
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    
    # Write to console
    if ($Level -eq 'Error') {
        Write-Error $Message
    } else {
        Write-Host $Message
    }
    
    # Write to log file
    Add-Content -Path $LOG_FILE -Value $logMessage
}

# Adds a path to the system PATH environment variable.
# This is persistent across reboots.
function Add-ToSystemPath {
    param(
        [Parameter(Mandatory=$true)]
        [string]$PathToAdd
    )
    
    # Get the current PATH from the registry.
    $currentPath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    
    # Split the PATH into an array and remove empty entries.
    $pathArray = $currentPath.Split(';', [System.StringSplitOptions]::RemoveEmptyEntries)
    
    # Check if the path already exists in the PATH.
    if ($pathArray -notcontains $PathToAdd) {
        # Add the new path to the array.
        $pathArray += $PathToAdd
        
        # Join the array back into a string.
        $newPath = $pathArray -join ';'
        
        # Update the PATH in the registry.
        [Environment]::SetEnvironmentVariable('Path', $newPath, 'Machine')
        
        Write-Log "Added $PathToAdd to system PATH"
        return $true
    } else {
        Write-Log "$PathToAdd is already in system PATH"
        return $false
    }
}

# Reloads the environment variables. Magically this also reloads the parent shell.
# We call this because the Puppet Agent installer adds itself to the PATH
# and we need to make sure that it is available in the current shell.
function Update-EnvironmentVariables {
    # Get all environment variables from the registry.
    $envVars = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
    
    # Update each environment variable in the current session
    $envVars.PSObject.Properties | ForEach-Object {
        if ($_.Name -ne 'PSPath' -and $_.Name -ne 'PSParentPath' -and $_.Name -ne 'PSChildName' -and $_.Name -ne 'PSDrive' -and $_.Name -ne 'PSProvider') {
            [Environment]::SetEnvironmentVariable($_.Name, $_.Value, 'Process')
        }
    }
    
    Write-Log "Environment variables reloaded"
}

# Installs the Puppet Agent.
function Install-PuppetAgent {
    param(
        [Parameter(Mandatory=$false)]
        [string]$StartupMode = "Disabled",
        
        [Parameter(Mandatory=$false)]
        [string]$LogFile = "C:\Windows\Logs\puppet-install.log"
    )
    
    $msiPath = Join-Path -Path $INSTALLER_DIR -ChildPath $PUPPET_MSI
    
    # Create installer directory if it doesn't exist
    New-DirectorySafe -Path $INSTALLER_DIR
    
    # Download the MSI if it doesn't exist
    if (-not (Test-Path $msiPath)) {
        Write-Log "Downloading Puppet agent installer..."
        try {
            Invoke-WebRequest -Uri $PUPPET_DOWNLOAD_URL -OutFile $msiPath
            Write-Log "Download completed successfully"
        }
        catch {
            Write-Log "Failed to download Puppet agent installer: $_" -Level Error
            return $false
        }
    }
    
    try {
        $arguments = @(
            "/passive",
            "/norestart",
            "/l*vx",
            $LogFile,
            "/i",
            $msiPath,
            "PUPPET_AGENT_STARTUP_MODE=$StartupMode"
        )
        
        $process = Start-Process -FilePath "msiexec.exe" -ArgumentList $arguments -Wait -PassThru
        
        if ($process.ExitCode -eq 0) {
            Write-Log "Puppet agent installed successfully"
            return $true
        } else {
            Write-Log "Puppet agent installation failed with exit code: $($process.ExitCode)" -Level Error
            return $false
        }
    }
    catch {
        Write-Log "Error installing Puppet agent: $_" -Level Error
        return $false
    }
}

function Install-TurboPuppet {
    param(
        [Parameter(Mandatory=$false)]
        [string]$branch = "turbopuppet"
    )
    # Install TurboPuppet.ps1
    $turbopuppetUrl = "https://raw.githubusercontent.com/CFCC/TurboPuppet/refs/heads/$branch/scripts/TurboPuppet.ps1"
    Invoke-WebRequest -Uri $turbopuppetUrl -OutFile "$BIN_DIR\TurboPuppet.ps1" -Force

    # Install Install-TurboPuppet.ps1
    $installerUrl = "https://raw.githubusercontent.com/CFCC/TurboPuppet/refs/heads/$branch/scripts/Install-TurboPuppet.ps1"
    Invoke-WebRequest -Uri $installerUrl -OutFile "$BIN_DIR\Install-TurboPuppet.ps1" -Force
}

# Create necessary directories.
New-DirectorySafe -Path "$ROOT_DIR\etc\TurboPuppet"
New-DirectorySafe -Path $BIN_DIR
New-DirectorySafe -Path "$ROOT_DIR\logs"

# Add bin directory to system PATH.
$null = Add-ToSystemPath -PathToAdd $BIN_DIR

# Install Puppet agent.
$null = Install-PuppetAgent

# Reload environment variables.
Update-EnvironmentVariables

# Install the TurboPuppet script
$null = Install-TurboPuppet