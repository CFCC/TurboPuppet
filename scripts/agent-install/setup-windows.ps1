# Download the Puppet Agent

$elevated_script = @'
&{
Write-Host "Enter this computers name. Examples of proper formatting:";
Write-Host "    CFCCZOTAC05";
Write-Host "    CFCCNUC01";
Write-Host "    CFCCTESTVM02";
Rename-Computer;
Write-Host "Sleeping for 5 seconds...";
Sleep 5;
}
'@
Start-Process powershell -verb runAs -ArgumentList $elevated_script

$puppet_local_package='puppet-agent-6.3.0-x64.msi'
$puppet_download_directory='C:\Users\camper\Downloads'

if (!(Test-Path $puppet_download_directory\$puppet_local_package)) {
    Invoke-WebRequest https://downloads.puppetlabs.com/windows/puppet6/$puppet_local_package -OutFile $puppet_download_directory\$puppet_local_package
}

cd $puppet_download_directory
msiexec /passive /norestart /l*v puppet-install.txt /i $puppet_local_package PUPPET_MASTER_SERVER=puppet PUPPET_AGENT_STARTUP_MODE=Manual
