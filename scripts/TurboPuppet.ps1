#! /usr/bin/env pwsh

param(
    [string]$branch = "production",
    [string]$role = "roles::camper::generic",
    [switch]$debug,
    [switch]$noop,
    [switch]$cached,
    [switch]$skip_gems,
    [switch]$skip_modules,
    [switch]$quick
)

$PUPPET_DATA_DIR = "C:\ProgramData\PuppetLabs"
$PUPPET_ROOT_DIR = "C:\Program Files\Puppet Labs\Puppet"
$PUPPET_BIN_DIR = "$PUPPET_ROOT_DIR\puppet\bin"
$PUPPET_SSL_DIR = "$PUPPET_ROOT_DIR\puppet\ssl"
$PUPPET_CODE_DIR = "$PUPPET_DATA_DIR\code"
$PUPPET_ENVIRONMENTS_DIR = "$PUPPET_CODE_DIR\environments"
$CODE_REPO_URL = "https://github.com/CFCC/TurboPuppet"
$ENVIRONMENT_DIR = Join-Path $PUPPET_ENVIRONMENTS_DIR $branch

function Get-GitBranchArchive {
    if ($cached -or $quick) {
        Write-Host "Using cached branch $branch"
        return
    }

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

<#
This needs to be the main section rather than agent or user because we need
the fact later on.
#>
function Set-PuppetEnvironment {
    $currentEnvironment = puppet config print environment
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
    
    Write-Host "Executing puppet apply with arguments: puppet apply $($applyArgs -join ' ')"
    puppet apply @applyArgs
}

<#
This is some bullshit.
https://github.com/puppetlabs/r10k/issues/1238
https://github.com/puppetlabs/puppet-agent/blob/main/resources/files/windows/environment.bat#L24
#>
function Prepare-Certificates {
    $caCertBundlePath = Join-Path $PUPPET_SSL_DIR "turbopuppet-cacerts.pem"
    if (-not (Test-Path $caCertBundlePath)) {
        Write-Host "Downloading CA certificates bundle..."
        Invoke-WebRequest -Uri "https://curl.se/ca/cacert.pem" -OutFile $caCertBundlePath
    }
    $env:SSL_CERT_FILE = $caCertBundlePath
    Write-Host "CA certificates bundle (SSL_CERT_FILE) set to $caCertBundlePath"
}

function Install-PuppetModules {
    $puppetfilePath = Join-Path $ENVIRONMENT_DIR "Puppetfile"
    
    if (-not (Test-Path $puppetfilePath)) {
        Write-Error "Puppetfile not found at $puppetfilePath"
        exit 1
    }

    Prepare-Certificates
    
    Write-Host "Installing modules from Puppetfile..."
    & "$PUPPET_BIN_DIR\r10k.bat" puppetfile install --puppetfile $puppetfilePath --moduledir "$ENVIRONMENT_DIR\modules"
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to install modules from Puppetfile"
        exit 1
    }
    
    Write-Host "Successfully installed modules from Puppetfile"
}

<#
Installing with the Gemfile caused some weird errors. Since all I need is r10k 
I'm going to do it manually here for now.
#>
function Install-Gems {
    Write-Host "Installing r10k..."
    & "$PUPPET_BIN_DIR\gem.bat" install r10k --version '~> 3.15.4'
    Write-Host "Successfully installed all gems"
}

$null = Get-GitBranchArchive
Set-PuppetEnvironment
if (-not ($skip_gems -or $quick)) {
    Install-Gems
}
if (-not ($skip_modules -or $quick)) {
    Install-PuppetModules
}
Run-Puppet
