#! /usr/bin/env pwsh

param(
    [string]$branch = "production",
    [string]$role = "roles::camper::generic_v2",
    [switch]$debug,
    [switch]$noop
)

$PUPPET_ROOT_DIR = "C:\ProgramData\PuppetLabs"
$PUPPET_CODE_DIR = "$PUPPET_ROOT_DIR\code"
$PUPPET_ENVIRONMENTS_DIR = "$PUPPET_CODE_DIR\environments"
$PUPPET_BASEMODULES_DIR = "$PUPPET_CODE_DIR\modules"
$CODE_REPO_URL = "https://github.com/CFCC/TurboPuppet"
$GEM_BINARY = "C:\Program Files\Puppet Labs\Puppet\puppet\bin\gem.bat"
$ENVIRONMENT_DIR = Join-Path $PUPPET_ENVIRONMENTS_DIR $branch

function Get-GitBranchArchive {
    $zipPath = Join-Path $env:TEMP "TurboPuppet-$branch.zip"
    
    # Remove existing directory if it exists
    if (Test-Path $ENVIRONMENT_DIR) {
        Remove-Item -Path $ENVIRONMENT_DIR -Recurse -Force
    }
    
    # Create the directory
    New-Item -ItemType Directory -Path $ENVIRONMENT_DIR -Force | Out-Null
    
    # Download the zip archive
    $downloadUrl = "$CODE_REPO_URL/archive/refs/heads/$branch.zip"
    Write-Host "Downloading branch $branch from $downloadUrl"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath
    
    # Extract the zip file
    Write-Host "Extracting archive to $ENVIRONMENT_DIR"
    Expand-Archive -Path $zipPath -DestinationPath $ENVIRONMENT_DIR -Force
    
    # Clean up the zip file
    Remove-Item -Path $zipPath -Force
    
    # Move the contents from the extracted subdirectory to the main directory
    $extractedDir = Get-ChildItem -Path $ENVIRONMENT_DIR -Directory | Select-Object -First 1
    if ($extractedDir) {
        Get-ChildItem -Path $extractedDir.FullName | Move-Item -Destination $ENVIRONMENT_DIR -Force
        Remove-Item -Path $extractedDir.FullName -Force
    }
    
    Write-Host "Successfully downloaded and extracted branch $branch"
}

function Set-PuppetEnvironment {
    $currentEnvironment = puppet config print --section user environment
    if ($currentEnvironment -ne $branch) {
        Write-Host "Changing Puppet environment from $currentEnvironment to $branch"
        puppet config set environment $branch
    } else {
        Write-Host "Puppet environment already set to $branch"
    }
}

function Run-Puppet {
    $applyArgs = @("-e", "include $role")
    
    if ($debug) {
        $applyArgs += "--debug"
    }
    
    if ($noop) {
        $applyArgs += "--noop"
    }
    
    puppet apply @applyArgs
}

function Install-PuppetModules {
    $puppetfilePath = Join-Path $ENVIRONMENT_DIR "Puppetfile"
    
    if (-not (Test-Path $puppetfilePath)) {
        Write-Host "Puppetfile not found at $puppetfilePath"
        return
    }
    
    Write-Host "Installing modules from Puppetfile..."
    # @TODO NO
    r10k puppetfile install --puppetfile $puppetfilePath --moduledir "$ENVIRONMENT_DIR\modules"
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to install modules from Puppetfile"
        exit 1
    }
    
    Write-Host "Successfully installed modules from Puppetfile"
}

function Install-Gems {
    $gemfilePath = Join-Path $ENVIRONMENT_DIR "Gemfile"
    
    if (-not (Test-Path $gemfilePath)) {
        Write-Host "Gemfile not found at $gemfilePath"
        return
    }
    
    if (-not (Test-Path $GEM_BINARY)) {
        Write-Error "Gem binary not found at $GEM_BINARY"
        exit 1
    }
    
    Write-Host "Installing gems from Gemfile..."
    & $GEM_BINARY install --local --file $gemfilePath
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to install gems from Gemfile"
        exit 1
    }
    
    Write-Host "Successfully installed gems from Gemfile"
}

$null = Get-GitBranchArchive
Set-PuppetEnvironment
Install-Gems
# Install-PuppetModules
Run-Puppet