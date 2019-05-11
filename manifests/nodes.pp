#
# Node inventory. Hosts in here will have a single role that they
# are assigned. Everything else come from that role.
#
node default { include role::base }

### Camper Machines ###
# Wumboze
node /^cfccnuc01/ { include role::cfcc::camper::pyle }
node /^cfccnuc02/ { include role::cfcc::camper::java }
node /^cfccnuc03/ { include role::cfcc::camper::test }
node /^cfccnuc04/ { include role::cfcc::camper::web }
node /^cfcczotac01/ { include role::cfcc::camper::test }
node /^cfcczotac02/ { include role::cfcc::camper::pyle }
node /^cfcczotac03/ { include role::cfcc::camper::test }
node /^cfcczotac04/ { include role::cfcc::camper::pyle }
node /^cfcczotac05/ { include role::cfcc::camper::pyle }
node /^cfcczotac06/ { include role::cfcc::camper::pyle }
node /^cfcczotac07/ { include role::cfcc::camper::test }
node /^cfcczotac08/ { include role::cfcc::camper::web }
node /^cfcczotac09/ { include role::cfcc::camper::pyle }
node /^cfcczotac10/ { include role::cfcc::camper::web }

# Mac
node /^cfccmac01/ { include role::cfcc::camper::java }

# Various
node /^cfcctestvm01/ { include role::cfcc::camper::test }
node /^cfcctestvm02/ { include role::cfcc::camper::pyle }
node /^cfcctestvm03/ {  include role::cfcc::camper::test }

### Server Infrastructure ###
node /^lancache/ { include role::cfcc::server::lancache }
# Ideas:
# - Steam Cache
# - DNS
# - DHCP
# - Game Servers
# - Central File Server
