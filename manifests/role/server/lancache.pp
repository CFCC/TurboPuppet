#
#
#
# @TODO inherit role::server
class role::server::lancache inherits role::base {
    include profile::lancache::web::nginx
    include profile::lancache::web::sniproxy
    include profile::lancache::dns
}
