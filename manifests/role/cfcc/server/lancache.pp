#
#
#
class role::cfcc::server::lancache inherits role::cfcc::server {
    include profile::lancache::web::nginx
    include profile::lancache::web::sniproxy
    include profile::lancache::dns
}
