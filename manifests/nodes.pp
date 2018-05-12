#
# Node inventory. Hosts in here will have a single role that they
# are assigned. Everything else come from that role.
#
node default {
    # Nothing!
}

### Camper Machines ###
node /^cfccnuc01/ { include role::camper::pyle }
node /^cfccnuc02/ { include role::camper::java }
# node /^cfcczotac01/ { include role::camper::java }
# node /^cfcczotac02/ { include role::camper::java }
node /^cfcczotac03/ { include role::camper::pyle }
node /^cfcczotac04/ { include role::camper::pyle }
# node /^cfcczotac05/ { include role::camper::java }
# node /^cfcczotac06/ { include role::camper::java }
# node /^cfcczotac07/ { include role::camper::java }

node /^cfcctestvm01/ { include role::camper::test }

### Server Infrastructure ###
# @TODO Someday!
# Ideas:
# - Steam Cache
# - DNS
# - DHCP
# - Game Servers
# - Central File Server