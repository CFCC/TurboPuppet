#!/usr/bin/env bash

pkg install --yes puppet6-6.3.0_1

# This is the default but lets just be consistent with other platforms
puppet config set server puppet

# We don't need to disable the agent service because FreeBSD doesnt
# attempt to let it start on boot. (puppet_enabled=YES -> rc.conf)
