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

function Get-GitBranchArchive {
    $branchDir = Join-Path $PUPPET_ENVIRONMENTS_DIR $branch
    $zipPath = Join-Path $env:TEMP "TurboPuppet-$branch.zip"
    
    # Remove existing directory if it exists
    if (Test-Path $branchDir) {
        Remove-Item -Path $branchDir -Recurse -Force
    }
    
    # Create the directory
    New-Item -ItemType Directory -Path $branchDir -Force | Out-Null
    
    # Download the zip archive
    $downloadUrl = "$CODE_REPO_URL/archive/refs/heads/$branch.zip"
    Write-Host "Downloading branch $branch from $downloadUrl"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath
    
    # Extract the zip file
    Write-Host "Extracting archive to $branchDir"
    Expand-Archive -Path $zipPath -DestinationPath $branchDir -Force
    
    # Clean up the zip file
    Remove-Item -Path $zipPath -Force
    
    # Move the contents from the extracted subdirectory to the main directory
    $extractedDir = Get-ChildItem -Path $branchDir -Directory | Select-Object -First 1
    if ($extractedDir) {
        Get-ChildItem -Path $extractedDir.FullName | Move-Item -Destination $branchDir -Force
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

$null = Get-GitBranchArchive
Set-PuppetEnvironment
Run-Puppet