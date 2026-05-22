#! /usr/bin/env pwsh

param(
    [string]$branch = "production",
    [string]$role = "roles::camper::generic",
    [switch]$debug,
    [switch]$noop,
    [switch]$cached,
    [switch]$skip_gems,
    [switch]$skip_modules,
    [switch]$quick,
    [string]$tags
)

$PUPPET_DATA_DIR = "C:\ProgramData\PuppetLabs"
$PUPPET_ROOT_DIR = "C:\Program Files\Puppet Labs\Puppet"
$PUPPET_BIN_DIR = "$PUPPET_ROOT_DIR\puppet\bin"
$PUPPET_SSL_DIR = "$PUPPET_ROOT_DIR\puppet\ssl"
$caCertBundlePath = Join-Path $PUPPET_SSL_DIR "turbopuppet-cacerts.pem"
$PUPPET_CODE_DIR = "$PUPPET_DATA_DIR\code"
$PUPPET_ENVIRONMENTS_DIR = "$PUPPET_CODE_DIR\environments"
$CODE_REPO_URL = "https://github.com/CFCC/TurboPuppet"
$ENVIRONMENT_DIR = Join-Path $PUPPET_ENVIRONMENTS_DIR $branch

function Write-Log {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] $Message"
}

function Get-GitBranchArchive {
    if ($cached -or $quick) {
        Write-Log "Using cached branch $branch"
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
    Write-Log "Downloading branch $branch from $downloadUrl"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath
    
    # Extract the zip file
    Write-Log "Extracting archive to $ENVIRONMENT_DIR"
    Expand-Archive -Path $zipPath -DestinationPath $ENVIRONMENT_DIR -Force
    
    # Clean up the zip file
    Remove-Item -Path $zipPath -Force
    
    # Move the contents from the extracted subdirectory to the main directory
    $extractedDir = Get-ChildItem -Path $ENVIRONMENT_DIR -Directory | Select-Object -First 1
    if ($extractedDir) {
        Get-ChildItem -Path $extractedDir.FullName | Move-Item -Destination $ENVIRONMENT_DIR -Force
        Remove-Item -Path $extractedDir.FullName -Force
    }
    
    Write-Log "Successfully downloaded and extracted branch $branch"
}

<#
This needs to be the main section rather than agent or user because we need
the fact later on.
#>
function Set-PuppetEnvironment {
    $currentEnvironment = puppet config print environment
    if ($currentEnvironment -ne $branch) {
        Write-Log "Changing Puppet environment from $currentEnvironment to $branch"
        puppet config set environment $branch
    } else {
        Write-Log "Puppet environment already set to $branch"
    }
}

function Setup-PuppetSsl {
    $certname   = puppet config print certname
    $opensslBin = Join-Path $PUPPET_BIN_DIR "openssl.exe"
    $caKey      = Join-Path $PUPPET_SSL_DIR "turbopuppet_ca_key.pem"
    $caCert     = Join-Path $PUPPET_SSL_DIR "turbopuppet_ca.pem"
    $keyPath    = Join-Path $PUPPET_SSL_DIR "private_keys\$certname.pem"
    $certPath   = Join-Path $PUPPET_SSL_DIR "certs\$certname.pem"
    $combinedCa = Join-Path $PUPPET_SSL_DIR "combined_ca.pem"

    if (-not (Test-Path $opensslBin)) {
        Write-Error "OpenSSL not found at $opensslBin"
        exit 1
    }

    New-Item -ItemType Directory -Path (Join-Path $PUPPET_SSL_DIR "private_keys") -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $PUPPET_SSL_DIR "certs")         -Force | Out-Null

    if (-not (Test-Path $caCert)) {
        Write-Log "Generating TurboPuppet local CA"
        & $opensslBin genrsa -out $caKey 4096
        & $opensslBin req -new -x509 -key $caKey -out $caCert `
            -days 3650 -subj "/CN=TurboPuppet Local CA"
    }

    if (-not (Test-Path $keyPath) -or -not (Test-Path $certPath)) {
        Write-Log "Generating SSL keypair for $certname"
        $csrPath = Join-Path $PUPPET_SSL_DIR "node_csr.pem"
        & $opensslBin genrsa -out $keyPath 4096
        & $opensslBin req -new -key $keyPath -out $csrPath -subj "/CN=$certname"
        & $opensslBin x509 -req -in $csrPath `
            -CA $caCert -CAkey $caKey -CAcreateserial `
            -out $certPath -days 3650
        Write-Log "SSL keypair signed by local CA for $certname"
    }

    $localCaContent  = Get-Content $caCert -Raw
    $systemCaContent = Get-Content $caCertBundlePath -Raw
    Set-Content -Path $combinedCa -Value ($localCaContent + $systemCaContent)
    Write-Log "Combined CA bundle written to $combinedCa"
}

function Run-Puppet {
    $applyArgs = @("-e", "include $role")
    
    if ($debug) {
        $applyArgs += "--debug"
    }
    
    if ($noop) {
        $applyArgs += "--noop"
    }

    if ($tags) {
        $applyArgs += "--tags"
        $applyArgs += $tags
    }

    $applyArgs += "--localcacert"
    $applyArgs += (Join-Path $PUPPET_SSL_DIR "combined_ca.pem")
    $applyArgs += "--certificate_revocation"
    $applyArgs += "false"

    Write-Log "Executing puppet apply with arguments: puppet apply $($applyArgs -join ' ')"
    puppet apply @applyArgs
}

<#
This is some bullshit.
https://github.com/puppetlabs/r10k/issues/1238
https://github.com/puppetlabs/puppet-agent/blob/main/resources/files/windows/environment.bat#L24
#>
function Prepare-Certificates {
    if (-not (Test-Path $caCertBundlePath)) {
        Write-Log "Downloading CA certificates bundle..."
        Invoke-WebRequest -Uri "https://curl.se/ca/cacert.pem" -OutFile $caCertBundlePath
    }
    $env:SSL_CERT_FILE = $caCertBundlePath
    Write-Log "CA certificates bundle (SSL_CERT_FILE) set to $caCertBundlePath"
}

function Install-PuppetModules {
    $puppetfilePath = Join-Path $ENVIRONMENT_DIR "Puppetfile"
    
    if (-not (Test-Path $puppetfilePath)) {
        Write-Error "Puppetfile not found at $puppetfilePath"
        exit 1
    }

    Write-Log "Installing modules from Puppetfile..."
    & "$PUPPET_BIN_DIR\r10k.bat" puppetfile install --puppetfile $puppetfilePath --moduledir "$ENVIRONMENT_DIR\modules"
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to install modules from Puppetfile"
        exit 1
    }
    
    Write-Log "Successfully installed modules from Puppetfile"
}

<#
Installing with the Gemfile caused some weird errors. Since all I need is r10k 
I'm going to do it manually here for now.
#>
function Install-Gems {
    Write-Log "Installing r10k..."
    & "$PUPPET_BIN_DIR\gem.bat" install r10k --version '~> 3.15.4'
    Write-Log "Successfully installed all gems"
}

$null = Get-GitBranchArchive
Set-PuppetEnvironment
if (-not ($skip_gems -or $quick)) {
    Install-Gems
}
Prepare-Certificates
Setup-PuppetSsl
if (-not ($skip_modules -or $quick)) {
    Install-PuppetModules
}
Run-Puppet
