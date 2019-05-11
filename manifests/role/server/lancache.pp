#
#
#
# @TODO inherit role::server
class role::server::lancache inherits role::base {
    include profile::lancache::web
    include profile::lancache::dns
}
