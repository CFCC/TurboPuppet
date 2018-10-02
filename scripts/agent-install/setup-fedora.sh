#!/bin/bash

curl -o /tmp/puppet-agent-5.5.6-1.fc28.x86_64.rpm http://yum.puppetlabs.com/puppet5/fedora/28/x86_64/puppet-agent-5.5.6-1.fc28.x86_64.rpm
sudo dnf install -y /tmp/puppet-agent-5.5.6-1.fc28.x86_64.rpm
