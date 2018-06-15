#
# Node inventory. Hosts in here will have a single role that they
# are assigned. Everything else come from that role.
#
node default { include role::camper::default }

### Camper Machines ###
node /^cfccnuc01/ { include role::camper::pyle }
node /^cfccnuc02/ { include role::camper::java }
node /^cfcczotac01/ { include role::camper::intro }
node /^cfcczotac02/ { include role::camper::java }
node /^cfcczotac03/ { include role::camper::pyle }
node /^cfcczotac04/ { include role::camper::test }
node /^cfcczotac05/ { include role::camper::test }
# node /^cfcczotac06/ { include role::camper::java }
# node /^cfcczotac07/ { include role::camper::java }
# node /^cfcczotac08/ { include role::camper::java }

# node /^cfcczotac09/ { include role::camper::java }
# node /^cfcczotac10/ { include role::camper::java }
# node /^cfcczotac11/ { include role::camper::java }

node /^cfcctestvm01/ { include role::camper::test }
node /^cfcctestvm02/ { include role::camper::pyle }

node /^cfccdocker01/ { include role::server::container::master }

### Server Infrastructure ###
# Ideas:
# - Steam Cache
# - DNS
# - DHCP
# - Game Servers
# - Central File Server
