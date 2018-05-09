# Download the Puppet Agent
$puppet_local_package='puppet-agent-latest-x64.msi'
$puppet_download_directory='C:\Users\camper\Downloads'

if (!(Test-Path $puppet_download_directory\$puppet_local_package)) {
    Invoke-WebRequest https://downloads.puppetlabs.com/windows/puppet-agent-x64-latest.msi -OutFile $puppet_download_directory\$puppet_local_package
}

cd $puppet_download_directory
msiexec /passive /norestart /l*v puppet-install.txt /i $puppet_local_package PUPPET_MASTER_SERVER=puppet.grantcohoe.com