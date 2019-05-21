#
# Node inventory. Hosts in here will have a single role that they
# are assigned. Everything else come from that role.
#
node default { include role::base }

### Camper Machines ###
# Wumboze
node /^cfccnuc01/ { include role::camper::generic }
node /^cfccnuc02/ { include role::camper::generic }
node /^cfccnuc03/ { include role::camper::generic }
node /^cfccnuc04/ { include role::camper::generic }
node /^cfcczotac01/ { include role::camper::generic }
node /^cfcczotac02/ { include role::camper::generic }
node /^cfcczotac03/ { include role::camper::generic }
node /^cfcczotac04/ { include role::camper::test }
node /^cfcczotac05/ { include role::camper::generic }
node /^cfcczotac06/ { include role::camper::generic }
node /^cfcczotac07/ { include role::camper::generic }
node /^cfcczotac08/ { include role::camper::generic }
node /^cfcczotac09/ { include role::camper::generic }
node /^cfcczotac10/ { include role::camper::generic }

# Mac
node /^cfccmac01/ { include role::camper::java }

# Various
node /^cfcctestvm01/ { include role::camper::test }
node /^cfcctestvm02/ { include role::camper::generic }
node /^cfcctestvm03/ {  include role::camper::test }

### Server Infrastructure ###
node /^lancache/ { include role::server::lancache }
# Ideas:
# - Steam Cache
# - DNS
# - DHCP
# - Game Servers
# - Central File Server
